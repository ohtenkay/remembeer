import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/user_card.dart';

class FriendsListPage extends StatelessWidget {
  final String userId;

  FriendsListPage({super.key, required this.userId});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Friends'),
      child: AsyncBuilder<List<UserModel>>(
        stream: _userService.friendsFor(userId),
        builder: (context, friends) {
          if (friends.isEmpty) {
            return const Center(child: Text('This user has no friends yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return UserCard(user: friends[index]);
            },
          );
        },
      ),
    );
  }
}
