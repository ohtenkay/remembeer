import 'package:flutter/material.dart';
import 'package:remembeer/auth/widget/username_page.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';

const _ICON_SIZE = 30.0;

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _userService = get<UserService>();
  final _userStatsService = get<UserStatsService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: AsyncBuilder(
        stream: _userStatsService.userStatsStream,
        builder: (context, userStats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 30),
                _buildTopRow(userStats),
                const SizedBox(height: 30),
                _buildConsumptionStats(userStats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return AsyncBuilder(
      stream: _userService.currentUserStream,
      builder: (context, user) {
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/avatars/${user.avatarName}'),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const UserNamePage(),
                  ),
                );
              },
              child: Text(
                user.username,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(UserStats userStats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          icon: Icons.local_fire_department,
          color: userStats.isStreakActive
              ? Colors.orange.shade700
              : Colors.grey,
          value: userStats.streakDays.toString(),
          label: 'Day Streak',
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          // TODO(metju-ac): replace with real value
          icon: Icons.people_alt,
          color: Colors.blue.shade700,
          value: '12',
          label: 'Friends',
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    required Widget icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSection({
    required String title,
    required double beersConsumed,
    required double alcoholConsumed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Divider(color: Colors.black26, height: 20, thickness: 1),
        _buildStatTile(
          label: 'Beers Consumed',
          value: beersConsumed.toStringAsFixed(1),
          icon: const DrinkIcon(
            category: DrinkCategory.Beer,
            size: _ICON_SIZE,
          ),
        ),
        _buildStatTile(
          label: 'Alcohol Consumed (ml)',
          value: alcoholConsumed.toStringAsFixed(0),
          icon: const DrinkIcon(
            category: DrinkCategory.Wine,
            size: _ICON_SIZE,
          ),
        ),
      ],
    );
  }

  Widget _buildConsumptionStats(UserStats userStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consumption Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatSection(
                  title: 'Last 30 Days',
                  beersConsumed: userStats.beersConsumedLast30Days,
                  alcoholConsumed: userStats.alcoholConsumedLast30Days,
                ),
                const SizedBox(height: 24),
                _buildStatSection(
                  title: 'Total Lifetime',
                  beersConsumed: userStats.totalBeersConsumed,
                  alcoholConsumed: userStats.totalAlcoholConsumed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
