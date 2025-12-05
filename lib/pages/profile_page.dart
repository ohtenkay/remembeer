import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/friend_request/model/friendship_status.dart';
import 'package:remembeer/friend_request/widget/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/friends_list_page.dart';
import 'package:remembeer/user/widget/search_user_page.dart';
import 'package:remembeer/user/widget/username_page.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';
import 'package:rxdart/rxdart.dart';

const _iconSize = 30.0;

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
        stream: Rx.combineLatest2(userStatsStream, userStream, (stats, user) {
          return (stats: stats, user: user);
        }),
        builder: (context, data) {
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
                  user: data.user,
                  isCurrentUser: isCurrentUser,
                ),
                const SizedBox(height: 30),
                _buildTopRow(
                  context: context,
                  userStats: data.stats,
                  user: data.user,
                ),
                const SizedBox(height: 30),
                _buildConsumptionStats(data.stats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader({
    required BuildContext context,
    required UserModel user,
    required bool isCurrentUser,
  }) {
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
        if (isCurrentUser)
          _buildCurrentUserActions(context)
        else
          _buildOtherUserActions(context, user),
      ],
    );
  }

  Widget _buildCurrentUserActions(BuildContext context) {
    return Column(
      children: [
        AsyncBuilder<List<FriendRequest>>(
          stream: _userService.pendingFriendRequests(),
          builder: (context, requests) {
            if (requests.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => FriendRequestsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: Text('View ${requests.length} friend request(s)'),
              ),
            );
          },
        ),
        ElevatedButton.icon(
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
        ),
      ],
    );
  }

  Widget _buildOtherUserActions(BuildContext context, UserModel user) {
    return AsyncBuilder(
      stream: _userService.friendshipStatus(user.id),
      builder: (context, status) {
        final VoidCallback onPressed;
        final IconData icon;
        final String label;

        switch (status) {
          case FriendshipStatus.friends:
            onPressed = () => _userService.removeFriend(user.id);
            icon = Icons.person_remove;
            label = 'Remove friend';
          case FriendshipStatus.requestSent:
            onPressed = () => _userService.revokeFriendRequest(user.id);
            icon = Icons.cancel_schedule_send;
            label = 'Revoke sent request';
          case FriendshipStatus.requestReceived:
            onPressed = () => _userService.acceptFriendRequest(user.id);
            icon = Icons.check_circle;
            label = 'Accept request';
          case FriendshipStatus.notFriends:
            onPressed = () => _userService.sendFriendRequest(user.id);
            icon = Icons.person_add;
            label = 'Add as friend';
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
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 32),
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
      ),
    );
  }

  Widget _buildTopRow({
    required BuildContext context,
    required UserStats userStats,
    required UserModel user,
  }) {
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
          icon: Icons.people_alt,
          color: Colors.blue.shade700,
          value: user.friends.length.toString(),
          label: 'Friends',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => FriendsListPage(userId: user.id),
            ),
          ),
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
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const Divider(color: Colors.black26, height: 20, thickness: 1),
        _buildStatTile(
          label: 'Beers Consumed',
          value: beersConsumed.toStringAsFixed(1),
          icon: const DrinkIcon(category: DrinkCategory.beer, size: _iconSize),
        ),
        _buildStatTile(
          label: 'Alcohol Consumed (ml)',
          value: alcoholConsumed.toStringAsFixed(0),
          icon: const DrinkIcon(category: DrinkCategory.wine, size: _iconSize),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
