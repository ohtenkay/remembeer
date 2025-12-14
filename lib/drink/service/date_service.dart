import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DateService {
  final _selectedDateSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get selectedDateStream => _selectedDateSubject.stream;

  DateTime get _selectedDate => _selectedDateSubject.value;

  void setDate(DateTime date) {
    _selectedDateSubject.add(date);
  }

  void nextDay() {
    _selectedDateSubject.add(_selectedDate.add(const Duration(days: 1)));
  }

  void previousDay() {
    _selectedDateSubject.add(_selectedDate.subtract(const Duration(days: 1)));
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
