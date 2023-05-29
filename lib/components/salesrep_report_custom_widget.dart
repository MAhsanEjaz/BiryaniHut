import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/size_config.dart';

class SalesRepReportCustomWidget extends StatelessWidget {
  final String reportImage;
  final Function()? onTap;

  const SalesRepReportCustomWidget(
      {Key? key, required this.reportImage, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
            height: getProportionateScreenHeight(150),
            width: SizeConfig.screenWidth,
            child: SvgPicture.asset(reportImage)));
  }
}
