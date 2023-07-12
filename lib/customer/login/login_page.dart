import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/forget_password/forget_password.dart';
import 'package:shop_app/customer/screens/home/customer_home_page.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/providers/user_data_provider.dart';
import 'package:shop_app/sales%20rep/salesrep_dashboard.dart';
import 'package:shop_app/services/login_api_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import 'package:shop_app/customer/register/register_page.dart';
import 'package:shop_app/size_config.dart';

import '../../components/common_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  final emailCont = TextEditingController(); //text: 'umair@gmail.com'

  final passCont = TextEditingController(); //text: '123123  '

  bool isEmailError = false;

  bool isPassError = false;

  String emailErrorString = '';

  String passErrorString = '';

  Map<String, dynamic> body = {};

  late UserModel userModel;

  LoginStorage loginStorage = LoginStorage();

  int? role;

  _loginHandler() async {
    CustomLoader.showLoader(context: context);

    var res = await LoginApiService().loginService(
        context: context, password: passCont.text, email: emailCont.text);

    print('response----->$res');

    CustomLoader.hideLoader(context);

    if (res) {
      role = Provider.of<UserDataProvider>(context, listen: false)
          .user!
          .data!
          .roleId;
      print("Role $role");
      // String message =
      //     Provider.of<UserDataProvider>(context, listen: false).user!.message;
      if (role == 1) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerHomePage(),
            ));
        showToast("Login Successfully");
      } else if (role == 2) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SalesRepDashboardPage(),
            ));
        showToast("Login Successfully");
      }
    } else {
      showToast("Credentials Invalid");
    }
  }

  bool _capsOn = false;
  bool isObscure = true;
  @override
  void initState() {
    super.initState();
    // userModel = Provider.of<UserDataProvider>(context, listen: false).user!;
    // log("userModel name = ${userModel.data!.firstName}");
    // passCont.addListener(_checkCaps);
  }

  @override
  void dispose() {
    passCont.removeListener(_checkCaps);
    passCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "LOGIN",
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(.30),
                  ),
                  Image.asset(
                    "assets/images/Influance-logo.png",
                    height: 200,
                    width: 499,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lets Sign You In",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(28),
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You have been missed alot",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          color: kSecondaryColor),
                    ),
                  ),
                  CustomTextField(
                      controller: emailCont,
                      isEnabled: true,
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "Email",
                      inputType: TextInputType.emailAddress,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Mail.svg",
                      )),
                  //! email error string
                  if (isEmailError) formErrorText(error: emailErrorString),
                  CustomTextField(
                    controller: passCont,
                    obscureText: isObscure,
                    isshowPasswordControls: true,
                    isEnabled: true,
                    inputType: TextInputType.visiblePassword,
                    hint: "Password",
                    suffixWidget: IconButton(
                      onPressed: () {
                        isObscure = !isObscure;
                        setState(() {});
                      },
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: isObscure ? appColor : kPrimaryColor,
                      ),
                    ),
                    onChange: (value) {
                      _checkCaps();
                    },
                    prefixWidget: SvgPicture.asset(
                      "assets/icons/Lock.svg",
                    ),
                  ),
                  //! password error string
                  if (isPassError) formErrorText(error: passErrorString),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(
                                    isReseller: false,
                                  ),
                                ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Don't have Account ?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordPage(),
                                ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Forget Password ?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),

                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),

                  DefaultButton(
                    text: "Login",
                    press: () {
                      // // if (isLoginValidated()) {
                      // log('isLoginValid valid');
                      // body = {"email": emailCont.text, "password": passCont.text};

                      // print(body);
                      if (isLoginValidated()) {
                        _loginHandler();
                      }
                      // } else {
                      //   log('isLoginValid not valid');
                      // }
                    },
                  ),
                  const Text("Version 6.0.0"),

                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoginValidated() {
    bool isValid = true;
    isEmailError = false;
    isPassError = false;
    if (!emailValidatorRegExp.hasMatch(emailCont.text)) {
      emailErrorString = "Email not valid !";
      isEmailError = true;
      isValid = false;
    }

    if (passCont.text.isEmpty) {
      passErrorString = "Please enter password";
      isPassError = true;
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _checkCaps() {
    setState(() {
      _capsOn = passCont.text.isNotEmpty
          ? passCont.text.characters.last ==
              passCont.text.characters.last.toUpperCase()
          : false;
    });

    if (isLetter(passCont.text.characters.last) && _capsOn) {
      CustomSnackBar.showSnackBar(
          context: context,
          message: "Caps lock is on",
          bgColor: Colors.black87);
    }
  }
}
