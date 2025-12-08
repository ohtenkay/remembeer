import 'dart:math';

import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';

const inviteCodeLength = 8;
const _inviteCodeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

class LeaderboardService {
  final AuthService authService;
  final LeaderboardController leaderboardController;
  final _random = Random.secure();

  LeaderboardService({
    required this.authService,
    required this.leaderboardController,
  });

  Future<Leaderboard?> findByInviteCode(String inviteCode) =>
      leaderboardController.findByInviteCode(inviteCode);

  Future<void> createLeaderboard(String name) async {
    final inviteCode = await _generateUniqueInviteCode();
    final currentUserId = authService.authenticatedUser.uid;

    await leaderboardController.createSingle(
      LeaderboardCreate(
        name: name,
        userIds: {currentUserId},
        inviteCode: inviteCode,
      ),
    );
  }

  Future<void> updateLeaderboardName({
    required String leaderboardId,
    required String newName,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);

    if (leaderboard.name == newName) {
      return;
    }

    final updatedLeaderboard = leaderboard.copyWith(name: newName);

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> joinLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userIds.contains(currentUserId)) {
      return;
    }

    final updatedLeaderboard = leaderboard.copyWith(
      userIds: {...leaderboard.userIds, currentUserId},
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<String> _generateUniqueInviteCode() async {
    String code;
    var isUnique = false;

    do {
      code = _generateRandomCode();
      final existingLeaderboard = await leaderboardController.findByInviteCode(
        code,
      );
      isUnique = existingLeaderboard == null;
    } while (!isUnique);

    return code;
  }

  String _generateRandomCode() {
    return List.generate(
      inviteCodeLength,
      (_) => _inviteCodeChars[_random.nextInt(_inviteCodeChars.length)],
    ).join();
  }
}
