import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserService {
  final AuthService authService;
  final UserController userController;

  const UserService({
    required this.authService,
    required this.userController,
  });

  Future<UserModel> get currentUser => userController.currentUser;

  Stream<UserModel> get currentUserStream => userController.currentUserStream;

  Stream<UserModel> userStreamFor(String userId) =>
      userController.userStreamFor(userId);

  Future<List<UserModel>> searchUsersByUsername(String query) =>
      userController.searchUsersByUsername(query);

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
}
