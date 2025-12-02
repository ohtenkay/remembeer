import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/friend_request/model/friendship_status.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/search_user_page.dart';
import 'package:remembeer/user/widget/username_page.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';

const _ICON_SIZE = 30.0;

class ProfilePage extends StatelessWidget {
  final String? userId;

  ProfilePage({super.key, this.userId});

  final _userService = get<UserService>();
  final _userStatsService = get<UserStatsService>();

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = userId == null;

    final userStream = isCurrentUser
        ? _userService.currentUserStream
        : _userService.userStreamFor(userId!);
    final userStatsStream = isCurrentUser
        ? _userStatsService.userStatsStream
        : _userStatsService.userStatsStreamFor(userId!);

    return PageTemplate(
      title: isCurrentUser ? null : const Text('Profile'),
      child: AsyncBuilder(
        stream: userStatsStream,
        builder: (context, userStats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(
                  context: context,
                  userStream: userStream,
                  isCurrentUser: isCurrentUser,
                ),
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

  Widget _buildProfileHeader({
    required BuildContext context,
    required Stream<UserModel> userStream,
    required bool isCurrentUser,
  }) {
    return AsyncBuilder(
      stream: userStream,
      builder: (context, user) {
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/avatars/${user.avatarName}'),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: isCurrentUser
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const UserNamePage(),
                        ),
                      );
                    }
                  : null,
              child: _buildUsernameLabel(user),
            ),
            const SizedBox(height: 12),
            _buildProfileButton(
              context: context,
              user: user,
              isCurrentUser: isCurrentUser,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileButton({
    required BuildContext context,
    required UserModel user,
    required bool isCurrentUser,
  }) {
    if (isCurrentUser) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const SearchUserPage(),
            ),
          );
        },
        icon: const Icon(Icons.search),
        label: const Text('Search for friends'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }

    return AsyncBuilder(
      stream: _userService.friendshipStatus(user.id),
      builder: (context, status) {
        final VoidCallback onPressed;
        final IconData icon;
        final String label;

        switch (status) {
          case FriendshipStatus.friends:
            onPressed = () {
              _userService.removeFriend(user.id);
            };
            icon = Icons.person_remove;
            label = 'Remove friend';
            break;
          case FriendshipStatus.requestSent:
            onPressed = () {
              _userService.revokeFriendRequest(user.id);
            };
            icon = Icons.cancel_schedule_send;
            label = 'Revoke sent request';
            break;
          case FriendshipStatus.requestReceived:
            onPressed = () {
              _userService.acceptFriendRequest(user.id);
            };
            icon = Icons.check_circle;
            label = 'Accept request';
            break;
          case FriendshipStatus.notFriends:
            onPressed = () {
              _userService.sendFriendRequest(user.id);
            };
            icon = Icons.person_add;
            label = 'Add as friend';
            break;
        }

        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildUsernameLabel(UserModel user) {
    return Text(
      user.username,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
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
