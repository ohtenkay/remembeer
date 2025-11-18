import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/user_data/model/user_data.dart';

class UserDataController {
  final AuthService authService;

  UserDataController({required this.authService});

  final _userDataCollection = FirebaseFirestore.instance
      .collection('user_data')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return UserData.fromJson(json.withId(snapshot.id));
        },
        toFirestore: (value, _) => value.toJson().withoutId(),
      );

  Stream<UserData> get userDataStream => _userDataCollection
      .doc(authService.authenticatedUser.uid)
      .snapshots()
      .map((docSnapshot) {
        final data = docSnapshot.data();
        if (data == null) {
          throw StateError(
            'User data not found for user ${authService.authenticatedUser.uid}',
          );
        }
        return data;
      });

  Future<UserData> get getCurrentUserData async {
    final doc = await _userDataCollection
        .doc(authService.authenticatedUser.uid)
        .get();

    final data = doc.data();
    if (data == null) {
      throw StateError(
        'User data not found for user ${authService.authenticatedUser.uid}',
      );
    }

    return data;
  }

  Future<void> createOrUpdateUserData(UserData userData) {
    if (userData.id != authService.authenticatedUser.uid) {
      throw StateError(
        'UserData id (${userData.id}) does not match authenticated user id '
        '(${authService.authenticatedUser.uid}).',
      );
    }

    return _userDataCollection.doc(userData.id).set(userData);
  }
}
