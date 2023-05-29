import 'package:flutter/material.dart';

class CustomTextIconButton extends StatelessWidget {
  final IconData? icon;
  final Function()? onTap;
  final Color borderColor;
  final double borderRadius;
  final String text;
  final double verticalMargin;

  const CustomTextIconButton(
      {Key? key,
      this.icon,
      this.onTap,
      this.borderColor = Colors.blue,
      this.borderRadius = 8.0,
      required this.text,
      this.verticalMargin = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalMargin),
      child: TextButton.icon(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(color: borderColor))),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }
}
