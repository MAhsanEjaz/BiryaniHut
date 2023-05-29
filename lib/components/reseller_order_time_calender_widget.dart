import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResellerOrderTimeDateWidget extends StatelessWidget {
  final IconData? icon;
  final String text;
  const ResellerOrderTimeDateWidget({Key? key, this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}
