import 'package:flutter/material.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';

class LeaderboardCard extends StatelessWidget {
  final Leaderboard leaderboard;
  final VoidCallback? onTap;

  const LeaderboardCard({super.key, required this.leaderboard, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memberCount = leaderboard.userIds.length;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.emoji_events,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(leaderboard.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
