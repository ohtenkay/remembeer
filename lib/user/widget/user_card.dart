import 'package:flutter/material.dart';
import 'package:remembeer/pages/profile_page.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatars/${user.avatarName}'),
          ),
          title: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ProfilePage(userId: user.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
