import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class MultilineCustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hint;
  Widget? prefixWidget;
  final Widget? suffixWidget;
  TextStyle? hintTextStyle;
  bool? isEnabled;
  List<TextInputFormatter>? inputFormats;
  int? maxlines;
  int? minlines;
  TextInputType? inputType;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final String? errorText;

  MultilineCustomTextField(
      {Key? key,
      this.controller,
      this.inputFormats,
      this.hint = '',
      this.prefixWidget,
      this.inputType,
      this.suffixWidget,
      this.maxlines,
      this.isEnabled,
      this.hintTextStyle,
      this.onSubmit,
      this.focusNode,
      this.onChange,
      this.minlines,
      this.errorText})
      : super(key: key);

  @override
  State<MultilineCustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<MultilineCustomTextField> {
  @override
  void initState() {
    super.initState();

    // widget.isObscure ?? false;
    widget.isEnabled ?? true;
    // widget.isshowPasswordControls;
    widget.maxlines ?? 3;
    widget.minlines ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      // padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        inputFormatters: widget.inputFormats,
        maxLines: widget.maxlines,
        focusNode: widget.focusNode,
        onSubmitted: widget.onSubmit,
        minLines: widget.minlines,
        controller: widget.controller,
        enabled: widget.isEnabled,
        keyboardType: widget.inputType ?? TextInputType.text,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(5),
              vertical: getProportionateScreenWidth(9)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: widget.hint,
          hintStyle: widget.hintTextStyle,
          errorText: widget.errorText,
          suffixIcon: widget.suffixWidget,
          prefixIcon: widget.prefixWidget == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.prefixWidget,
                ),
        ),
      ),
    );
    ;
  }
}
