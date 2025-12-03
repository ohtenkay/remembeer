import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  void _changeDay(int delta) {
    final newDate = widget.selectedDate.add(Duration(days: delta));
    widget.onDateChanged(newDate);
  }

  void _showCalendarDrawer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CalendarDrawer(
        selectedDate: widget.selectedDate,
        onDateSelected: (date) {
          widget.onDateChanged(date);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final selectedDay = DateTime(date.year, date.month, date.day);

    return switch (selectedDay.difference(DateTime.now()).inDays) {
      0 => 'Today',
      -1 => 'Yesterday',
      1 => 'Tomorrow',
      _ => DateFormat('EEEE, d MMMM yyyy').format(date),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCalendarDrawer,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) {
          return;
        }

        if (details.primaryVelocity! > 0) {
          _changeDay(-1); // Swiped right - go to previous day
        } else if (details.primaryVelocity! < 0) {
          _changeDay(1); // Swiped left - go to next day
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeDay(-1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatDate(widget.selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeDay(1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarDrawer extends StatelessWidget {
  const _CalendarDrawer({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Select Date',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: onDateSelected,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => onDateSelected(DateTime.now()),
                child: const Text('Today'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
