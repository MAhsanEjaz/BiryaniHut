import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class ResellerDashboardVerticalCardWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final String imageUrl;
  final String subTitle;
  const ResellerDashboardVerticalCardWidget(
      {Key? key,
      required this.title,
      this.onTap,
      required this.imageUrl,
      required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          leading: SvgPicture.asset(
            imageUrl,
            height: 40.0,
            width: 40.0,
          ),
          title: Text(title),
          subtitle: Text(
            subTitle,
            style: dayStyle,
          ),
        ),
      ),
    );
  }
}
