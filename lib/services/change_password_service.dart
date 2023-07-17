import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

class ChangePasswordService {
  Future changePasswordService(
      {required BuildContext context,
      String? email,
      String? otp,
      String? newPassword}) async {
    try {
      Map body = {"email": email, "otp": otp, "newPassword": newPassword};

      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          url: '$apiBaseUrl/login/UpdatePassword',
          body: body);

      if (res['statusCode'] == 400) {
        CustomSnackBar.failedSnackBar(
            context: context, message: 'OTP has expired');

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
