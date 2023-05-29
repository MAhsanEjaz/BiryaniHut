import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  const SearchField({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.controller, this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * .85,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(

        controller: controller,
        onSubmitted: onSubmit,
        onChanged: (onChanged),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: const Icon(Icons.search),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
