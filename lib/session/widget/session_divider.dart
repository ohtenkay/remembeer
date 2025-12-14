import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionDivider extends StatelessWidget {
  final Session session;

  SessionDivider({super.key, required this.session});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('H:mm');
    final isOwner = _sessionService.isSessionOwner(session);

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
          if (isOwner) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => EditSessionPage(session: session),
                ),
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
