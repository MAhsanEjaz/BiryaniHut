import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';

class CustomLoader {
  static void showLoader({required BuildContext context}) {
    // AlertDialog androidDialog = AlertDialog(
    //   backgroundColor: Colors.transparent,
    //   content: SpinKitChasingDots(
    //     color: appColor,
    //     size: 50.0,
    //   ),
    // );
    log('loader started ..');

    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: const Color(0x00ffffff),
        builder: (_) => const Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: SpinKitChasingDots(
                color: appColor,
                size: 50.0,
              ),
            ));
  }

  static void hideLoader(BuildContext context) {
    log('hiding loader..');
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
    // Navigator.of(context).pop();
  }
}

class LoaderContentWidget extends StatelessWidget {
  final String message;

  LoaderContentWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('will pop executed -->');
        return false;
      },
      child: const SpinKitChasingDots(
        color: appColor,
        size: 50.0,
      ),
    );
  }
}
