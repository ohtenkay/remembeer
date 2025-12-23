import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DateService {
  final _selectedDateSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get selectedDateStream => _selectedDateSubject.stream;

  DateTime get _selectedDate => _selectedDateSubject.value;

  bool get isToday => DateUtils.isSameDay(_selectedDate, DateTime.now());

  void setDate(DateTime date) {
    _selectedDateSubject.add(date);
  }

  void nextDay() {
    final now = DateTime.now();
    final nextDate = _selectedDate.add(const Duration(days: 1));

    if (nextDate.isAfter(now) && !DateUtils.isSameDay(nextDate, now)) {
      return;
    }

    _selectedDateSubject.add(nextDate);
  }

  void previousDay() {
    _selectedDateSubject.add(_selectedDate.subtract(const Duration(days: 1)));
  }

  void goToToday() {
    _selectedDateSubject.add(DateTime.now());
  }

  void dispose() {
    _selectedDateSubject.close();
  }

  // TODO(ohtenkay): try injecting settings here
  (DateTime, DateTime) selectedDateBoundaries(TimeOfDay endOfDayBoundary) {
    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      endOfDayBoundary.hour,
      endOfDayBoundary.minute,
    );

    final endTime = startTime.add(const Duration(days: 1));

    return (startTime, endTime);
  }
}
