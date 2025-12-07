import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/page/update_leaderboard_name_page.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/member_card.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';

class ManageLeaderboardPage extends StatelessWidget {
  final Leaderboard leaderboard;

  ManageLeaderboardPage({super.key, required this.leaderboard});

  final _userController = get<UserController>();
  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Leaderboard'),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildMembersSection(context),
          const SizedBox(height: 16),
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 48,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.emoji_events,
            size: 48,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _navigateToUpdateName(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(leaderboard.name, style: theme.textTheme.headlineSmall),
              const SizedBox(width: 8),
              Icon(
                Icons.edit,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Members (${leaderboard.memberIds.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildMembersList()),
        ],
      ),
    );
  }

  void _navigateToUpdateName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            UpdateLeaderboardNamePage(leaderboard: leaderboard),
      ),
    );
  }

  Widget _buildMembersList() {
    final memberIds = leaderboard.memberIds.toList();
    final ownerId = leaderboard.userId;

    return ListView.builder(
      itemCount: memberIds.length,
      itemBuilder: (context, index) {
        final userId = memberIds[index];
        final isOwner = userId == ownerId;

        return AsyncBuilder<UserModel>(
          future: _userController.userById(userId),
          builder: (context, user) {
            return MemberCard(user: user, isOwner: isOwner);
          },
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => _showDeleteConfirmationDialog(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error),
      ),
      icon: const Icon(Icons.delete),
      label: const Text('Delete Leaderboard'),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Leaderboard'),
        content: Text(
          'Are you sure you want to delete "${leaderboard.name}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await _leaderboardService.deleteLeaderboard(leaderboard.id);
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
