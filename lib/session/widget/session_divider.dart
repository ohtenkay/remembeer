import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/session/model/session.dart';

class SessionDivider extends StatelessWidget {
  final Session session;

  const SessionDivider({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('H:mm');

    final timeText = session.endedAt != null
        ? '${timeFormat.format(session.startedAt)} to ${timeFormat.format(session.endedAt!)}'
        : '${timeFormat.format(session.startedAt)} - still going';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.table_bar,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            session.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            timeText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO(session): Navigate to edit session page
            },
            child: Icon(
              Icons.edit_outlined,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
