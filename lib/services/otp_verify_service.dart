import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

class OtpVerifyService {
  Future otpVerifyService(
      {required BuildContext context, String? otp, String? email}) async {
    try {
      Map body = {"otp": otp, "email": email, "verified": true};

      var res = await CustomPostRequestService().httpPostRequest(
          context: context, url: '$apiBaseUrl/login/VerifyOtp', body: body);

      if (res['data']['verified'] == false) {
        CustomSnackBar.failedSnackBar(context: context, message: 'Otp Wrong');

        return false;
      } else {
        return true;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
