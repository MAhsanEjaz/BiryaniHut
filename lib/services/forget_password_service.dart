import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

class ForgetPasswordService {
  Future forgetPasswordService(
      {required BuildContext context, String? email}) async {
    try {
      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          url: '$apiBaseUrl/login/forgetPassword?email=$email',
          body: {});

      if (res['message'] == 'Success') {
        return true;
      } else if (res['message'] == 'Email is not Exist') {
        CustomSnackBar.failedSnackBar(
            context: context, message: 'Email not Exists');
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
