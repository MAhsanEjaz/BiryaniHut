import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/services/forget_password_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';

import '../../size_config.dart';
import '../screens/otp/otp_screen.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailCont = TextEditingController();

  bool isEmailError = false;

  String emailErrorString = '';

  forgetPasswordHandler() async {
    CustomLoader.showLoader(context: context);

    bool res = await ForgetPasswordService()
        .forgetPasswordService(context: context, email: emailCont.text);

    CustomLoader.hideLoader(context);

    if (res) {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Otp send to email');

      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => OtpScreen(
                    email: emailCont.text,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          // title: Text(
          //   "Forget Password",
          //   style: appbarTextStye,
          // ),
        ),
        //! add appbar for login, signup and forget page
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    // Image.asset(
                    //   "assets/images/Influance-logo.png",
                    //   height: getProportionateScreenHeight(150),
                    //   width: getProportionateScreenWidth(300),
                    // ),
                    // SizedBox(height: 30),

                    Image.asset(
                      "assets/images/biryani.png",
                      height: 200,
                      width: 499,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Forget Password ?",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            color: appColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Please enter your email, a code will be sent to your email to verify you . . . .",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 3),
                      child: CustomTextField(
                          controller: emailCont,
                          isEnabled: true,
                          obscureText: false,
                          isshowPasswordControls: false,
                          hint: "Email",
                          inputType: TextInputType.emailAddress,
                          prefixWidget: SvgPicture.asset(
                            "assets/icons/Mail.svg",
                          )),
                    ),
                    //! email error string
                    if (isEmailError) formErrorText(error: emailErrorString),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    DefaultButton(
                      text: "Send Code",
                      buttonColor: appColor,
                      press: () {
                        if (isValid()) {
                          forgetPasswordHandler();
                        }
                      },
                    )
                  ],
                )),

          ),
        ),
      ),
    );
  }

  bool isValid() {
    bool isValid = true;
    isEmailError = false;
    if (!emailValidatorRegExp.hasMatch(emailCont.text)) {
      emailErrorString = "Email not valid !";
      isEmailError = true;
      isValid = false;
    }

    setState(() {});
    return isValid;
  }
}
