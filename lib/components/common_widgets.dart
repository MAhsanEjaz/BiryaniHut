import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shop_app/constants.dart';

Widget showSpinkit() {
  return const SpinKitChasingDots(
    color: kPrimaryColor,
    size: 50.0,
  );
}

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showSnackbar(
    {required BuildContext context,
    required String title,
    required String desc}) {
  log("showSnackbar fired");
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: kPrimaryColor,
    content: Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  ));
}

alertDialogueWithLoader({required BuildContext context}) {
  log("alertDialogueWithLoader fired");
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        color: Colors.transparent,
        child: const Center(
            child: SizedBox(
          height: 70,
          width: 70,
          child: SpinKitFadingCircle(
            color: kPrimaryColor,
            size: 50.0,
          ),
        )),
      );
    },
  );
}
