import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/pages/profile_page.dart';
import 'package:remembeer/user/service/user_service.dart';

class FriendRequestCard extends StatelessWidget {
  final FriendRequest request;

  FriendRequestCard({super.key, required this.request});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userService.userById(request.userId),
      builder: (context, sender) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ProfilePage(userId: sender.id),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/avatars/${sender.avatarName}',
                ),
              ),
              title: Text(
                sender.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: SizedBox(
                width: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                      ),
                      onPressed: () =>
                          _userService.acceptFriendRequest(sender.id),
                      tooltip: 'Accept',
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red.shade600),
                      onPressed: () => _userService.denyFriendRequest(request),
                      tooltip: 'Deny',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
