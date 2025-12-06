import 'package:flutter/material.dart';
import 'package:remembeer/leaderboard/model/leaderboard_entry.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/user/page/profile_page.dart';

class StandingCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final LeaderboardType sortType;

  const StandingCard({super.key, required this.entry, required this.sortType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = sortType == LeaderboardType.beers
        ? entry.rankByBeers
        : entry.rankByAlcohol;
    final value = sortType == LeaderboardType.beers
        ? entry.beersConsumed
        : entry.alcoholConsumedMl;
    final unit = sortType == LeaderboardType.beers ? 'beers' : 'ml';

    final (cardColor, borderColor) = _getCardColors(context, rank);

    return Card(
      color: cardColor,
      shape: borderColor != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 2),
            )
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProfilePage(userId: entry.user.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '#$rank',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/avatars/${entry.user.avatarName}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.user.username,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)} $unit',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color?, Color?) _getCardColors(BuildContext context, int rank) {
    switch (rank) {
      case 1:
        return (const Color(0xFFE8B41E), const Color(0xFFA68900));
      case 2:
        return (const Color(0xFFAEAEAE), const Color(0xFF757575));
      case 3:
        return (const Color(0xFFC36A1D), const Color(0xFF7C4006));
      default:
        return (null, null);
    }
  }
}
