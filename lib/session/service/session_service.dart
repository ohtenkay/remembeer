import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:rxdart/rxdart.dart';

class SessionService {
  final AuthService authService;
  final SessionController sessionController;
  final DateService dateService;
  final UserSettingsController userSettingsController;

  SessionService({
    required this.authService,
    required this.sessionController,
    required this.dateService,
    required this.userSettingsController,
  });

  Stream<List<Session>> get mySessionsForSelectedDateStream {
    return Rx.combineLatest3(
      sessionController.mySessionsStream,
      dateService.selectedDateStream,
      userSettingsController.userSettingsStream,
      (sessions, selectedDate, userSettings) {
        final drinkListSort = userSettings.drinkListSort;
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          userSettings.endOfDayBoundary,
        );

        final filtered = sessions.where((session) {
          final startsBeforeDayEnds = session.startedAt.isBefore(endTime);
          final endsAfterDayStarts =
              session.endedAt == null || session.endedAt!.isAfter(startTime);
          return startsBeforeDayEnds && endsAfterDayStarts;
        }).toList();

        switch (drinkListSort) {
          case DrinkListSort.descending:
            filtered.sort((a, b) => b.startedAt.compareTo(a.startedAt));
          case DrinkListSort.ascending:
            filtered.sort((a, b) => a.startedAt.compareTo(b.startedAt));
        }

        return filtered;
      },
    );
  }

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
