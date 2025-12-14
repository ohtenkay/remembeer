import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';

class SessionController extends Controller<Session, SessionCreate> {
  SessionController({required super.authService})
    : super(collectionPath: 'sessions', fromJson: Session.fromJson);
}
