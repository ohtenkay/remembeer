import 'package:rxdart/rxdart.dart';

class DateService {
  final BehaviorSubject<DateTime> _selectedDateSubject =
      BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get selectedDateStream => _selectedDateSubject.stream;

  void setDate(DateTime date) {
    _selectedDateSubject.add(date);
  }

  void nextDay() {
    _selectedDateSubject.add(
      _selectedDateSubject.value.add(const Duration(days: 1)),
    );
  }

  void previousDay() {
    _selectedDateSubject.add(
      _selectedDateSubject.value.subtract(const Duration(days: 1)),
    );
  }

  void dispose() {
    _selectedDateSubject.close();
  }
}
