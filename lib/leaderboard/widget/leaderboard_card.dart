import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/page/leaderboard_detail_page.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';

class LeaderboardCard extends StatelessWidget {
  final Leaderboard leaderboard;

  LeaderboardCard({super.key, required this.leaderboard});

  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memberCount = leaderboard.memberIds.length;

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  LeaderboardDetailPage(leaderboard: leaderboard),
            ),
          );
        },
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
        trailing: _buildStandingInfo(context, theme),
      ),
    );
  }

  Widget _buildStandingInfo(BuildContext context, ThemeData theme) {
    return AsyncBuilder(
      stream: _leaderboardService.currentUserStandingStreamFor(leaderboard),
      builder: (context, leaderboardEntry) {
        if (leaderboardEntry == null) {
          return const Icon(Icons.chevron_right);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRankChip(
              theme,
              Icons.sports_bar,
              leaderboardEntry.rankByBeers,
            ),
            const SizedBox(width: 4),
            _buildRankChip(
              theme,
              Icons.local_bar,
              leaderboardEntry.rankByAlcohol,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        );
      },
    );
  }

  Widget _buildRankChip(ThemeData theme, IconData icon, int rank) {
    final isHighlighted = rank <= 3;
    final backgroundColor = _getRankColor(rank, theme);
    final foregroundColor = isHighlighted
        ? Colors.white
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 2),
          Text(
            '#$rank',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank, ThemeData theme) {
    switch (rank) {
      case 1:
        return const Color(0xFFE8B41E);
      case 2:
        return const Color(0xFF9C9B9B);
      case 3:
        return const Color(0xFFC36A1D);
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }
}
