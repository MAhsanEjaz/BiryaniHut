import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';

class ResellerHorizontalDashboardWidget extends StatelessWidget {
  final String imageUrl;
  final Function()? onTap;
  final String title;
  const ResellerHorizontalDashboardWidget(
      {Key? key, required this.imageUrl, this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 3.0),
          height: MediaQuery.of(context).size.height * 0.135,
          width: MediaQuery.of(context).size.width * 0.22,
          child: InkWell(
            onTap: onTap,
            child: Card(
              elevation: 3.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                  child: SvgPicture.asset(
                imageUrl,
                height: 45.0,
                width: 45.0,
              )),
            ),
          ),
        ),
        Text(
          "$title",
          style: const TextStyle(fontSize: 16, color: kPrimaryColor),
        )
      ],
    );
  }
}
