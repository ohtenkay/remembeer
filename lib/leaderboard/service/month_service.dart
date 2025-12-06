import 'package:remembeer/leaderboard/model/selected_month.dart';
import 'package:rxdart/rxdart.dart';

class MonthService {
  final _selectedMonthSubject = BehaviorSubject<SelectedMonth>.seeded(
    SelectedMonth(year: DateTime.now().year, month: DateTime.now().month),
  );

  Stream<SelectedMonth> get selectedMonthStream => _selectedMonthSubject.stream;

  SelectedMonth get currentSelection => _selectedMonthSubject.value;

  void previousMonth() {
    final current = _selectedMonthSubject.value;
    if (current.month == 1) {
      _selectedMonthSubject.add(
        SelectedMonth(year: current.year - 1, month: 12),
      );
    } else {
      _selectedMonthSubject.add(
        SelectedMonth(year: current.year, month: current.month - 1),
      );
    }
  }

  void nextMonth() {
    final current = _selectedMonthSubject.value;
    if (current.isCurrentMonth) {
      return;
    }

    if (current.month == 12) {
      _selectedMonthSubject.add(
        SelectedMonth(year: current.year + 1, month: 1),
      );
    } else {
      _selectedMonthSubject.add(
        SelectedMonth(year: current.year, month: current.month + 1),
      );
    }
  }

  void resetToCurrentMonth() {
    final now = DateTime.now();
    _selectedMonthSubject.add(SelectedMonth(year: now.year, month: now.month));
  }

  void dispose() {
    _selectedMonthSubject.close();
  }
}
