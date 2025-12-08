import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_name_form.dart';

class UpdateLeaderboardNamePage extends StatelessWidget {
  final Leaderboard leaderboard;

  UpdateLeaderboardNamePage({super.key, required this.leaderboard});

  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Update Leaderboard Name'),
      child: LeaderboardNameForm(
        initialName: leaderboard.name,
        submitButtonText: 'Save',
        onSubmit: (name) async {
          await _leaderboardService.updateLeaderboardName(
            leaderboardId: leaderboard.id,
            newName: name,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
