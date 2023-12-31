import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/login/login_page.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/services/change_password_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';

import '../../size_config.dart';

class ChangePasswordScreen extends StatefulWidget {
  String? email;
  String? otp;

  ChangePasswordScreen({super.key, this.otp, this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool isView = false;

  changePasswordHandler() async {
    CustomLoader.showLoader(context: context);

    bool res = await ChangePasswordService().changePasswordService(
        context: context,
        email: widget.email,
        newPassword: confirmPassword.text,
        otp: widget.otp);

    CustomLoader.hideLoader(context);

    if (res) {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Password Changed Successfully');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(.20),
                ),
                Image.asset(
                  "assets/images/Influance-logo.png",
                  height: 200,
                  width: 499,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    "Change your password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: newPassword,
                  obscureText: isView,
                  suffixWidget: InkWell(
                      onTap: () {
                        isView = !isView;
                        setState(() {});
                      },
                      child: Icon(isView
                          ? Icons.remove_red_eye
                          : Icons.visibility_off)),
                  prefixWidget: const Icon(Icons.lock),
                  hint: 'New Password',
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: confirmPassword,
                  obscureText: isView,
                  suffixWidget: InkWell(
                      onTap: () {
                        isView = !isView;
                        setState(() {});
                      },
                      child: Icon(isView
                          ? Icons.remove_red_eye
                          : Icons.visibility_off)),
                  prefixWidget: const Icon(Icons.lock),
                  hint: 'Confirm New Password',
                ),
                const SizedBox(height: 10),
                DefaultButton(
                    text: 'Change Password',
                    press: () {
                      if (validation()) {
                        changePasswordHandler();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (newPassword.text.isEmpty) {
      CustomSnackBar.failedSnackBar(
          context: context, message: 'Enter your password');
      return false;
    } else if (confirmPassword.text.isEmpty ||
        newPassword.text != confirmPassword.text) {
      CustomSnackBar.failedSnackBar(
          context: context, message: 'Password not matched');
      return false;
    } else {
      return true;
    }
  }
}
