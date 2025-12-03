import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/model/direction.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/drink/widget/calendar_drawer.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DateSelector extends StatelessWidget {
  DateSelector({super.key});

  final DateService _dateService = get<DateService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<DateTime>(
      stream: _dateService.selectedDateStream,
      builder: (context, datetime) {
        return GestureDetector(
          onTap: () => _showCalendarDrawer(context, datetime),
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) {
              return;
            }

            if (details.primaryVelocity! > 0) {
              _dateService.previousDay();
            } else if (details.primaryVelocity! < 0) {
              _dateService.nextDay();
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
                _buildChevron(Direction.Left),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(datetime),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                _buildChevron(Direction.Right),
              ],
            ),
          ),
        );
      },
    );
  }

  IconButton _buildChevron(Direction direction) {
    final icon = switch (direction) {
      Direction.Left => Icons.chevron_left,
      Direction.Right => Icons.chevron_right,
    };

    return IconButton(
      icon: Icon(icon),
      onPressed: _dateService.previousDay,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  void _showCalendarDrawer(BuildContext context, DateTime selectedDate) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CalendarDrawer(
        selectedDate: selectedDate,
        onDateSelected: (date) {
          _dateService.setDate(date);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return switch (date.difference(DateTime.now()).inDays) {
      0 => 'Today',
      -1 => 'Yesterday',
      1 => 'Tomorrow',
      _ => DateFormat('EEEE, d MMMM yyyy').format(date),
    };
  }
}
