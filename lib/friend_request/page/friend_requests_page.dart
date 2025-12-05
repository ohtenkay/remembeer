import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/friend_request/widget/friend_request_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';

class FriendRequestsPage extends StatelessWidget {
  FriendRequestsPage({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Friend Requests'),
      child: AsyncBuilder<List<FriendRequest>>(
        stream: _userService.pendingFriendRequests(),
        builder: (context, requests) {
          if (requests.isEmpty) {
            return const Center(
              child: Text('You have no pending friend requests.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return FriendRequestCard(request: requests[index]);
            },
          );
        },
      ),
    );
  }
}
