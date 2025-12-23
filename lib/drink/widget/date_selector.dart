import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/enum/swipe_direction.dart';
import 'package:remembeer/common/widget/async_builder.dart';
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
        final isToday = _dateService.isToday;

        return GestureDetector(
          onTap: () => _showDatePicker(context, datetime),
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) {
              return;
            }

            if (details.primaryVelocity! > 0) {
              _dateService.previousDay();
            } else if (details.primaryVelocity! < 0 && !isToday) {
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
                _buildChevron(direction: SwipeDirection.left),
                Column(
                  children: [
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
                    if (!isToday) ...[
                      const SizedBox(height: 4),
                      _buildReturnToToday(context),
                    ],
                  ],
                ),
                _buildChevron(
                  direction: SwipeDirection.right,
                  enabled: !isToday,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReturnToToday(BuildContext context) {
    return InkWell(
      onTap: _dateService.goToToday,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          'Return to today',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconButton _buildChevron({
    required SwipeDirection direction,
    bool enabled = true,
  }) {
    final (icon, moveFunction) = switch (direction) {
      SwipeDirection.left => (Icons.chevron_left, _dateService.previousDay),
      SwipeDirection.right => (Icons.chevron_right, _dateService.nextDay),
    };

    return IconButton(
      icon: Icon(icon),
      onPressed: enabled ? moveFunction : null,
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
      lastDate: DateTime.now(),
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
      _ => DateFormat('EEEE, d MMMM yyyy').format(date),
    };
  }
}
