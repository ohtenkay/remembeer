import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/friend_request/model/friend_request_create.dart';

class FriendRequestController
    extends Controller<FriendRequest, FriendRequestCreate> {
  FriendRequestController({required super.authService})
    : super(
        collectionPath: 'friend_requests',
        fromJson: FriendRequest.fromJson,
      );

  Stream<List<FriendRequest>> pendingFriendRequests() {
    return readCollection
        .where(deletedAtField, isNull: true)
        .where('toUserId', isEqualTo: authService.authenticatedUser.uid)
        .snapshots()
        .map(
          (querySnapshot) => List.unmodifiable(
            querySnapshot.docs
                .map((docSnapshot) => docSnapshot.data())
                .toList(),
          ),
        );
  }

  Stream<FriendRequest?> getRequestBetween(String otherUserId) {
    final currentUserId = authService.authenticatedUser.uid;
    return readCollection
        .where(deletedAtField, isNull: true)
        .where(
          Filter.or(
            Filter.and(
              Filter('userId', isEqualTo: currentUserId),
              Filter('toUserId', isEqualTo: otherUserId),
            ),
            Filter.and(
              Filter('userId', isEqualTo: otherUserId),
              Filter('toUserId', isEqualTo: currentUserId),
            ),
          ),
        )
        .snapshots()
        .map(
          (snapshot) {
            if (snapshot.docs.length > 1) {
              throw StateError(
                'Found ${snapshot.docs.length} pending friend requests between $currentUserId and $otherUserId. Expected at most 1.',
              );
            }
            if (snapshot.docs.isEmpty) {
              return null;
            }
            return snapshot.docs.first.data();
          },
        );
  }
}
