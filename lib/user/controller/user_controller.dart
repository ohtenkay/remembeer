import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserController {
  final AuthService authService;

  UserController({required this.authService});

  final _userCollection = FirebaseFirestore.instance
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return UserModel.fromJson(json.withId(snapshot.id));
        },
        toFirestore: (value, _) => value.toJson().withoutId(),
      );

  Stream<UserModel> get currentUserStream => _userCollection
      .doc(authService.authenticatedUser.uid)
      .snapshots()
      .map((docSnapshot) {
        final data = docSnapshot.data();
        if (data == null) {
          throw StateError(
            'User not found for user ${authService.authenticatedUser.uid}',
          );
        }
        return data;
      });

  Future<UserModel> get currentUser async {
    final doc = await _userCollection
        .doc(authService.authenticatedUser.uid)
        .get();

    final data = doc.data();
    if (data == null) {
      throw StateError(
        'User not found for user ${authService.authenticatedUser.uid}',
      );
    }

    return data;
  }

  Future<List<UserModel>> searchUsersByUsername(String query) async {
    final queryLower = query.toLowerCase();

    final usernameQuery = _userCollection
        .where('searchableUsername', isGreaterThanOrEqualTo: queryLower)
        .where('searchableUsername', isLessThanOrEqualTo: '$queryLower\uf8ff')
        .limit(10)
        .get();

    final emailQuery = _userCollection
        .where('email', isGreaterThanOrEqualTo: queryLower)
        .where('email', isLessThanOrEqualTo: '$queryLower\uf8ff')
        .limit(10)
        .get();

    final results = await Future.wait([usernameQuery, emailQuery]);

    final userMap = <String, UserModel>{};
    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final user = doc.data();
        if (user.id != authService.authenticatedUser.uid) {
          userMap[user.id] = user;
        }
      }
    }

    return userMap.values.toList();
  }

  Future<void> createOrUpdateUser(UserModel user) {
    if (user.id != authService.authenticatedUser.uid) {
      throw StateError(
        'User id (${user.id}) does not match authenticated user id '
        '(${authService.authenticatedUser.uid}).',
      );
    }

    return _userCollection.doc(user.id).set(user);
  }
}
