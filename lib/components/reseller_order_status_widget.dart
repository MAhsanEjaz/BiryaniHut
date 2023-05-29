import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SalesrepOrdeStatusWidget extends StatelessWidget {
  final String shopStatusText;
  final bool bgColor;
  final Function()? onTap;
  final double topMargin;
  final double leftMargin;
  final double rightMargin;
  final bool isRep;

  const SalesrepOrdeStatusWidget(
      {Key? key,
      required this.shopStatusText,
      required this.bgColor,
      this.onTap,
      this.topMargin = 20.0,
      this.leftMargin = 0.0,
      this.rightMargin = 0.0,
      required this.isRep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            top: isRep ? 50 : topMargin, left: leftMargin, right: rightMargin),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ? appColor : lightBlackColor,
            borderRadius: BorderRadius.circular(30.0)),
        width: getProportionateScreenWidth(120),
        height: 45.0,
        child: Text(
          shopStatusText,
          style: TextStyle(
              color: bgColor ? whiteColor : kPrimaryColor,
              fontSize: bgColor ? 15.0 : 13.0,
              fontWeight: bgColor ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
