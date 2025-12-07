import 'dart:math';

import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';
import 'package:remembeer/leaderboard/model/leaderboard_entry.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';
import 'package:rxdart/rxdart.dart';

const inviteCodeLength = 8;
const maxLeaderboardMembers = 200;
const _inviteCodeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

class LeaderboardService {
  final AuthService authService;
  final MonthService monthService;

  final LeaderboardController leaderboardController;
  final UserController userController;

  // TODO(metju-ac): remove this after saving monthly stats in firestore
  final UserStatsService userStatsService;

  final _random = Random.secure();

  LeaderboardService({
    required this.authService,
    required this.monthService,
    required this.leaderboardController,
    required this.userController,
    required this.userStatsService,
  });

  Future<Leaderboard?> findByInviteCode(String inviteCode) =>
      leaderboardController.findByInviteCode(inviteCode);

  Future<void> createLeaderboard(String name) async {
    final inviteCode = await _generateUniqueInviteCode();
    final currentUserId = authService.authenticatedUser.uid;

    await leaderboardController.createSingle(
      LeaderboardCreate(
        name: name,
        memberIds: {currentUserId},
        inviteCode: inviteCode,
      ),
    );
  }

  Future<void> updateLeaderboardName({
    required String leaderboardId,
    required String newName,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);

    if (leaderboard.userId != authService.authenticatedUser.uid) {
      throw StateError('Only the owner can update the leaderboard name.');
    }

    if (leaderboard.name == newName) {
      return;
    }

    final updatedLeaderboard = leaderboard.copyWith(name: newName);

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> leaveLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userId == currentUserId) {
      throw StateError('The owner cannot leave their own leaderboard.');
    }

    final updatedMemberIds = Set<String>.from(leaderboard.memberIds)
      ..remove(currentUserId);

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: updatedMemberIds,
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<bool> joinLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.memberIds.contains(currentUserId)) {
      return true;
    }

    if (leaderboard.memberIds.length >= maxLeaderboardMembers) {
      return false;
    }

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: {...leaderboard.memberIds, currentUserId},
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
    return true;
  }

  bool isOwner(Leaderboard leaderboard) {
    return leaderboard.userId == authService.authenticatedUser.uid;
  }

  Stream<List<LeaderboardEntry>> standingsStreamFor(Leaderboard leaderboard) {
    return monthService.selectedMonthStream.switchMap(
      (selectedMonth) => _standingsStreamForMonth(
        leaderboard: leaderboard,
        year: selectedMonth.year,
        month: selectedMonth.month,
      ),
    );
  }

  Stream<LeaderboardEntry?> currentUserStandingStreamFor(
    Leaderboard leaderboard,
  ) {
    final now = DateTime.now();
    final currentUserId = authService.authenticatedUser.uid;

    return _standingsStreamForMonth(
      leaderboard: leaderboard,
      year: now.year,
      month: now.month,
    ).map(
      (standings) =>
          standings.where((e) => e.user.id == currentUserId).firstOrNull,
    );
  }

  Stream<List<LeaderboardEntry>> _standingsStreamForMonth({
    required Leaderboard leaderboard,
    required int year,
    required int month,
  }) {
    final memberIds = leaderboard.memberIds.toList();

    // TODO(metju-ac): Optimize this by storing the monthly stats in firestore
    final statsStreams = memberIds.map(
      (userId) => userStatsService.monthlyStatsStreamFor(
        userId: userId,
        year: year,
        month: month,
      ),
    );

    return Rx.combineLatestList(statsStreams).asyncMap((statsList) async {
      final entries = <LeaderboardEntry>[];

      for (var i = 0; i < memberIds.length; i++) {
        final memberId = memberIds[i];
        final stats = statsList[i];
        final user = await userController.userById(memberId);

        entries.add(
          LeaderboardEntry(
            user: user,
            beersConsumed: stats.beersConsumed,
            alcoholConsumedMl: stats.alcoholConsumedMl,
            rankByBeers: 0,
            rankByAlcohol: 0,
          ),
        );
      }

      return _computeRanks(entries);
    });
  }

  List<LeaderboardEntry> _computeRanks(List<LeaderboardEntry> entries) {
    entries.sort((a, b) => b.beersConsumed.compareTo(a.beersConsumed));
    final byBeersRanks = <String, int>{};
    for (var i = 0; i < entries.length; i++) {
      byBeersRanks[entries[i].user.id] = i + 1;
    }

    entries.sort((a, b) => b.alcoholConsumedMl.compareTo(a.alcoholConsumedMl));
    final byAlcoholRanks = <String, int>{};
    for (var i = 0; i < entries.length; i++) {
      byAlcoholRanks[entries[i].user.id] = i + 1;
    }

    return entries
        .map(
          (e) => LeaderboardEntry(
            user: e.user,
            beersConsumed: e.beersConsumed,
            alcoholConsumedMl: e.alcoholConsumedMl,
            rankByBeers: byBeersRanks[e.user.id]!,
            rankByAlcohol: byAlcoholRanks[e.user.id]!,
          ),
        )
        .toList();
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
