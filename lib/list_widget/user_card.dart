import 'package:flutter/material.dart';
import 'package:movietrack/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onResetPassword;
  final VoidCallback onRemoveUser;

  const UserCard({
    Key? key,
    required this.user,
    required this.onResetPassword,
    required this.onRemoveUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePicture),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onResetPassword,
                  child: const Text('Reset', style: TextStyle(color: Colors.yellow)),
                ),
                TextButton(
                  onPressed: onRemoveUser,
                  child: const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}