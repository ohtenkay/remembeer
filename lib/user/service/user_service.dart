import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/friend_request/model/friend_request_create.dart';
import 'package:remembeer/friend_request/model/friendship_status.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final AuthService authService;
  final FriendRequestController friendRequestController;
  final UserController userController;

  const UserService({
    required this.authService,
    required this.friendRequestController,
    required this.userController,
  });

  Future<UserModel> get currentUser => userController.currentUser;

  Stream<UserModel> get currentUserStream => userController.currentUserStream;

  Future<UserModel> getUserById(String userId) =>
      userController.getUserById(userId);

  Stream<UserModel> userStreamFor(String userId) =>
      userController.userStreamFor(userId);

  Future<List<UserModel>> searchUsersByUsernameOrEmail(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return [];
    }
    return userController.searchUsersByUsernameOrEmail(trimmedQuery);
  }

  Stream<List<UserModel>> friendsFor(String userId) {
    return userController.userStreamFor(userId).switchMap((user) {
      if (user.friends.isEmpty) {
        return Stream.value([]);
      }

      final friendStreams = user.friends
          .map(userController.userStreamFor)
          .toList();

      return Rx.combineLatestList(friendStreams);
    });
  }

  Future<void> createDefaultUser() async {
    final defaultUser = UserModel(
      id: authService.authenticatedUser.uid,
      email: authService.authenticatedUser.email!,
      username:
          authService.authenticatedUser.displayName ??
          authService.authenticatedUser.email!,
    );

    await userController.createOrUpdateUser(defaultUser);
  }

  Future<void> updateUsername({required String newUsername}) async {
    final currentUser = await userController.currentUser;
    if (currentUser.username == newUsername) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      username: newUsername,
    );

    await userController.createOrUpdateUser(updatedUser);
  }

  Future<void> sendFriendRequest(String toUserId) async {
    await friendRequestController.createSingle(
      FriendRequestCreate(toUserId: toUserId),
    );
  }

  Future<void> revokeFriendRequest(String otherUserId) async {
    final request = await friendRequestController
        .getRequestBetween(
          otherUserId,
        )
        .first;

    if (request == null) {
      throw StateError(
        'No friend request found between current user and $otherUserId to revoke.',
      );
    }

    await friendRequestController.deleteSingle(request);
  }

  Future<void> acceptFriendRequest(String otherUserId) async {
    final request = await friendRequestController
        .getRequestBetween(
          otherUserId,
        )
        .first;
    if (request == null) {
      throw StateError(
        'No friend request found between current user and $otherUserId to accept.',
      );
    }

    final currentUser = await userController.currentUser;
    final otherUser = await userController.getUserById(otherUserId);

    final updatedCurrentUser = currentUser.addFriend(otherUserId);
    final updatedOtherUser = otherUser.addFriend(currentUser.id);

    final batch = friendRequestController.createBatch();

    userController.createOrUpdateInBatch(
      user: updatedCurrentUser,
      batch: batch,
    );
    userController.createOrUpdateInBatch(user: updatedOtherUser, batch: batch);
    friendRequestController.deleteSingleInBatch(entity: request, batch: batch);

    await batch.commit();
  }

  Future<void> removeFriend(String otherUserId) async {
    final currentUser = await userController.currentUser;
    final otherUser = await userController.getUserById(otherUserId);

    final updatedCurrentUser = currentUser.removeFriend(otherUserId);
    final updatedOtherUser = otherUser.removeFriend(currentUser.id);

    final batch = userController.createBatch();

    userController.createOrUpdateInBatch(
      user: updatedCurrentUser,
      batch: batch,
    );
    userController.createOrUpdateInBatch(user: updatedOtherUser, batch: batch);

    await batch.commit();
  }

  Stream<FriendshipStatus> friendshipStatus(String otherUserId) {
    return Rx.combineLatest2(
      currentUserStream,
      friendRequestController.getRequestBetween(otherUserId),
      (currentUser, request) {
        if (currentUser.friends.contains(otherUserId)) {
          return FriendshipStatus.friends;
        }

        if (request == null) {
          return FriendshipStatus.notFriends;
        }

        return (request.userId == currentUser.id)
            ? FriendshipStatus.requestSent
            : FriendshipStatus.requestReceived;
      },
    );
  }
}
