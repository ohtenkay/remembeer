import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session_create.dart';

class SessionService {
  final AuthService authService;
  final SessionController sessionController;

  SessionService({required this.authService, required this.sessionController});

  Future<void> createSession({
    required String name,
    required DateTime startedAt,
  }) async {
    final currentUserId = authService.authenticatedUser.uid;

    await sessionController.createSingle(
      SessionCreate(
        name: name,
        startedAt: startedAt,
        memberIds: {currentUserId},
      ),
    );
  }
}
