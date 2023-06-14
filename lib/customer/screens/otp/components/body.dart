import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/login/change_password_screen.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/services/otp_verify_service.dart';
import 'package:shop_app/size_config.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  String? email;

  Body({this.email});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  otpVerifyHandler(String? otp) async {
    CustomLoader.showLoader(context: context);

    var res = await OtpVerifyService()
        .otpVerifyService(context: context, email: widget.email, otp: otp);

    CustomLoader.hideLoader(context);

    if (res) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  ChangePasswordScreen(email: widget.email, otp: otp)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              const SizedBox(height: 10),

              RichText(
                  text: TextSpan(children: <TextSpan>[
                const TextSpan(
                    text: 'We sent your email',
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: ' ${widget.email}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ])),
              const SizedBox(height: 5),
              buildTimer(),
              // OtpForm(),

              const SizedBox(height: 20),
              OTPTextField(
                length: 5,
                outlineBorderRadius: 5,
                width: MediaQuery.of(context).size.width,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                fieldStyle: FieldStyle.box,
                onCompleted: (String pin) {
                  otpVerifyHandler(pin);

                  print("Completed: " + pin);
                },
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // OTP code resend
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 40.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(
                color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
