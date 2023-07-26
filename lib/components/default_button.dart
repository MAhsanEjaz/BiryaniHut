import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final Function()? press;
  final Color buttonColor;
  final double horizntalMargin;
  final double verticalMargin;
  final double height;
  final double width;

  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.buttonColor = appColor,
    this.height = 45.0,
    this.width = double.infinity,
    this.horizntalMargin = 0.0,
    this.verticalMargin = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: horizntalMargin, vertical: verticalMargin),
      child: TextButton(
        style: TextButton.styleFrom(
          // foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Color(0xff29aae1),
        ),
        onPressed: (press),
        child: Text(
          text!,
          style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
