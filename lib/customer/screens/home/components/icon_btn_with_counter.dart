import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/size_config.dart';

import '../../../../constants.dart';

class IconBtnWithCounter extends StatefulWidget {
  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfitem = 0,
    required this.press,
  }) : super(key: key);

  final String svgSrc;
  final int numOfitem;
  final GestureTapCallback press;

  @override
  State<IconBtnWithCounter> createState() => _IconBtnWithCounterState();
}

class _IconBtnWithCounterState extends State<IconBtnWithCounter> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: widget.press,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            // padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            // height: getProportionateScreenWidth(46),
            // width: getProportionateScreenWidth(46),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              widget.svgSrc,
              color: Colors.white,
            ),
          ),
          if (widget.numOfitem != 0)
            Positioned(
              top: -13,
              right: 0,
              child: Container(
                height: getProportionateScreenWidth(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "${widget.numOfitem}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
