import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hint;
  Widget? prefixWidget;
  final Widget? suffixWidget;
  bool obscureText;
  bool isshowPasswordControls;
  TextStyle? hintTextStyle;
  bool? isEnabled;
  List<TextInputFormatter>? inputFormats;
  int? maxlines;
  int? minlines;
  final String? headerText;
  TextInputType? inputType;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final String? errorText;

  CustomTextField(
      {Key? key,
      this.controller,
      this.inputFormats,
      this.hint = '',
      this.prefixWidget,
      this.inputType,
      this.suffixWidget,
      this.obscureText = false,
      this.isshowPasswordControls = false,
      this.maxlines,
      this.isEnabled,
      this.hintTextStyle,
      this.onSubmit,
      this.focusNode,
      this.onChange,
      this.minlines,
      this.errorText,
      this.headerText})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();

    // widget.isObscure ?? false;
    widget.isEnabled ?? true;
    // widget.isshowPasswordControls;
    widget.maxlines ?? 1;
    widget.minlines ?? 1;

    log("isObscure  = ${widget.obscureText}");
    log("isshowPasswordControls = ${widget.isshowPasswordControls}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headerText == null
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.headerText == null ? 0.0 : 6.0,
                    vertical: widget.headerText == null ? 0.0 : 4.0),
                child: Text(
                  widget.headerText!,
                  style: titleStyle,
                ),
              ),
        Container(
          height: 45.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0)),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            // maxLines: widget.maxlines == null? null:10,
            inputFormatters: widget.inputFormats,
            // maxLines: widget.isObscure == false ? widget.maxlines : null,
            focusNode: widget.focusNode,
            onSubmitted: widget.onSubmit,
            minLines: widget.minlines,
            controller: widget.controller,
            enabled: widget.isEnabled,
            keyboardType: widget.inputType ?? TextInputType.text,
            obscureText: widget.obscureText,
            onChanged: widget.onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(5), vertical: 6.0),
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
                      padding: const EdgeInsets.all(10.0),
                      child: widget.prefixWidget,
                    ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
