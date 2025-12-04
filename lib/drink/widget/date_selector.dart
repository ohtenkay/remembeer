import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/model/direction.dart';
import 'package:remembeer/drink/service/date_service.dart';
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
          onTap: () => _showDatePicker(context, datetime),
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
    final (icon, moveFunction) = switch (direction) {
      Direction.Left => (Icons.chevron_left, _dateService.previousDay),
      Direction.Right => (Icons.chevron_right, _dateService.nextDay),
    };

    return IconButton(
      icon: Icon(icon),
      onPressed: moveFunction,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    // TODO(ohtenkay): Try out a package like https://pub.dev/packages/syncfusion_flutter_datepicker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      _dateService.setDate(pickedDate);
    }
  }

  String _formatDate(DateTime datetime) {
    final date = DateUtils.dateOnly(datetime);
    final nowDate = DateUtils.dateOnly(DateTime.now());

    return switch (date.difference(nowDate).inDays) {
      0 => 'Today',
      -1 => 'Yesterday',
      1 => 'Tomorrow',
      _ => DateFormat('EEEE, d MMMM yyyy').format(date),
    };
  }
}
