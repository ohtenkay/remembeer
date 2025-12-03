import 'package:rxdart/rxdart.dart';

class DateService {
  final BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get selectedDateStream => _selectedDate.stream;

  DateTime get selectedDate => _selectedDate.value;

  void setDate(DateTime date) {
    _selectedDate.add(date);
  }

  void nextDay() {
    _selectedDate.add(_selectedDate.value.add(const Duration(days: 1)));
  }

  void previousDay() {
    _selectedDate.add(_selectedDate.value.subtract(const Duration(days: 1)));
  }

  void goToToday() {
    _selectedDate.add(DateTime.now());
  }

  void dispose() {
    _selectedDate.close();
  }
}
