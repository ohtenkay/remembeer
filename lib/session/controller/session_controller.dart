import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';

class SessionController extends Controller<Session, SessionCreate> {
  SessionController({required super.authService})
    : super(collectionPath: 'sessions', fromJson: Session.fromJson);

  Stream<List<Session>> get mySessionsStream {
    return readCollection
        .where(deletedAtField, isNull: true)
        .where('memberIds', arrayContains: authService.authenticatedUser.uid)
        .snapshots()
        .map(
          (querySnapshot) => List.unmodifiable(
            querySnapshot.docs
                .map((docSnapshot) => docSnapshot.data())
                .toList(),
          ),
        );
  }
}
