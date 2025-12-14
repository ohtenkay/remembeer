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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.colorScheme.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.table_bar,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 6),
                Text(
                  '${session.name} • ${timeFormat.format(session.startedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Divider(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }
}
