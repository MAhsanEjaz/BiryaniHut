import 'package:flutter/material.dart';
import 'package:shop_app/sales%20rep/timelines/models/user_model.dart';
import 'package:shop_app/sales%20rep/timelines/widgets/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    required this.user,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(imageUrl: user.imageUrl),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              user.name,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
