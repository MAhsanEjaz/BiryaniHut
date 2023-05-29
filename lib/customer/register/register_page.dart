import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/providers/regitration_provider.dart';
import 'package:shop_app/services/phone_format_service.dart';
import 'package:shop_app/services/register_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import 'package:shop_app/customer/login/login_page.dart';
import 'package:shop_app/size_config.dart';

import '../../sales rep/salesrep_customers.dart';

class SignUpPage extends StatefulWidget {
  final bool isReseller;

  const SignUpPage({Key? key, required this.isReseller}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpPage> {
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  final salonNameCont = TextEditingController();
  final stateCont = TextEditingController();
  final cityCont = TextEditingController();
  final fNameCont = TextEditingController();
  final lNameCont = TextEditingController();
  final confirmPassCont = TextEditingController();
  final phoneCont = TextEditingController();
  final addressCont = TextEditingController();

  bool isEmailError = false;
  bool isfNamaeError = false;
  bool islNameError = false;
  bool isPassError = false;
  bool isAddressError = false;
  bool isPhoneError = false;
  bool isConfrimPassError = false;
  bool isSalonError = false;
  bool isStateError = false;
  bool isCityError = false;

  String emailErrorString = '';
  String passErrorString = '';
  String fNamaeErrorString = '';
  String lNameErrorString = '';
  String phoneErrorString = '';
  String addressErrorString = '';
  String confirmPassErrorString = '';
  String salonNameErrorString = '';
  String stateNameErrorString = '';
  String cityNameErrorString = '';

  Map<String, dynamic> registerByCustomerBody = {};

  Map<String, dynamic> registerBySalesrepBody = {};

  registerHandler() async {
    CustomLoader.showLoader(context: context);
    bool isRegistered = await RegisterService().registerService(
        context: context,
        isReseller: widget.isReseller,
        body: registerByCustomerBody);
    CustomLoader.hideLoader(context);
    String? message = '';
    if (isRegistered) {
      message = Provider.of<RegistrationProvider>(context, listen: false)
          .registrationModel!
          .message;
    }

    if (message == 'Record Already Exists') {
      showToast('Customer Already Exists');
    } else if (isRegistered) {
      showToast('Customer Registered Successfully');

      if (widget.isReseller) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ResellerCustomersPage()));
      }
    } else {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Customer Registration Failed");
      // showToast('Customer Registration Failed');
    }
  }

  bool isObscure = true;

  bool _isCapsOn = false;

  File? _image;

  final image = ImagePicker();

  String? imagePath;
  String passChangedVal = '';

  @override
  void initState() {
    super.initState();
    phoneCont.addListener(() {
      setState(() {});
    });
  }

  // String _formatPhone(String phone) {
  //   phone = phone.replaceAll('-', '');
  //   if (phone.length <= 3) {
  //     return phone;
  //   } else if (phone.length <= 6) {
  //     return '${phone.substring(0, 3)}-${phone.substring(3)}';
  //   } else {
  //     return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6, 10)}';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: getProportionateScreenHeight(20),
                  // ),
                  Image.asset(
                    "assets/images/Influance-logo.png",
                    height: getProportionateScreenHeight(130),
                    width: getProportionateScreenWidth(300),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Customer Account",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(28),
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  if (!widget.isReseller)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hope you will enjoy us",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),

                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _image == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.black38),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/person.jpg'))),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  _image!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Positioned(
                        right: 1,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text('Camera'),
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            onTap: () async {
                                              final camImage =
                                                  await image.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (camImage != null) {
                                                _image = File(camImage.path);
                                                _convertImageToBase64();
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          ListTile(
                                            title: const Text('Gallery'),
                                            leading: const Icon(Icons.image),
                                            onTap: () async {
                                              final galImage =
                                                  await image.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (galImage != null) {
                                                _image = File(galImage.path);
                                                _convertImageToBase64();

                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          child: imagePath == null
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: appColor),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      )
                    ],
                  ),

                  CustomTextField(
                      controller: fNameCont,
                      isEnabled: true,
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "First Name",
                      inputType: TextInputType.text,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/User.svg",
                      )),
                  if (isfNamaeError) formErrorText(error: fNamaeErrorString),

                  CustomTextField(
                      controller: lNameCont,
                      isEnabled: true,
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "Last Name",
                      inputType: TextInputType.text,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/User.svg",
                      )),
                  if (islNameError) formErrorText(error: lNameErrorString),
                  CustomTextField(
                    controller: salonNameCont,
                    // isshowPasswordControls: true,
                    isEnabled: true,
                    hint: "Salon Name",
                    prefixWidget: SvgPicture.asset(
                      "assets/svg/Salon Name.svg",
                      color: Colors.black45,
                      width: 26,
                      height: 26,
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.centerLeft,
                    ),
                  ),

                  if (isSalonError) formErrorText(error: salonNameErrorString),

                  CustomTextField(
                    controller: stateCont,
                    // isshowPasswordControls: true,
                    isEnabled: true,
                    hint: "State Name",
                    prefixWidget: SvgPicture.asset(
                      "assets/svg/State Icon (1).svg",
                      width: 26,
                      height: 26,
                      alignment: Alignment.centerLeft,
                    ),
                  ),

                  if (isStateError) formErrorText(error: stateNameErrorString),

                  CustomTextField(
                    controller: cityCont,
                    // isshowPasswordControls: true,

                    isEnabled: true,
                    hint: "City Name",

                    prefixWidget: SvgPicture.asset(
                      "assets/svg/City Icon (1).svg",
                      color: Colors.black45,
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  if (isCityError) formErrorText(error: cityNameErrorString),

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
                      controller: phoneCont,
                      isEnabled: true,
                      inputFormats: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                        PhoneInputFormatter(),
                      ],
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "Phone",
                      inputType: TextInputType.number,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Phone.svg",
                      )),
                  if (isPhoneError) formErrorText(error: phoneErrorString),

                  CustomTextField(
                      controller: addressCont,
                      isEnabled: true,
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "Address",
                      inputType: TextInputType.text,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Location point.svg",
                      )),
                  if (isAddressError) formErrorText(error: addressErrorString),
                  if (!widget.isReseller)
                    CustomTextField(
                      controller: passCont,
                      obscureText: isObscure,
                      isshowPasswordControls: true,
                      isEnabled: true,
                      suffixWidget: IconButton(
                        onPressed: () {
                          isObscure = !isObscure;
                          setState(() {});
                        },
                        icon: Icon(isObscure == false
                            ? Icons.remove_red_eye
                            : Icons.visibility_off),
                      ),
                      inputType: TextInputType.visiblePassword,
                      hint: "Password",
                      onChange: (value) {
                        if (value.isEmpty) {
                          passChangedVal = '';
                        }
                        log("value.length = ${value.trim().length}");
                        log("passChangedVal.length = ${passChangedVal.trim().length}");
                        if (value.trim().length > passChangedVal.length) {
                          passChangedVal = value;
                          checkCaps(capsCont: passCont);
                        }
                      },
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Lock.svg",
                      ),
                    ),
                  //! password error string
                  if (isPassError) formErrorText(error: passErrorString),
                  if (!widget.isReseller)
                    CustomTextField(
                      suffixWidget: IconButton(
                        onPressed: () {
                          isObscure = !isObscure;
                          setState(() {});
                        },
                        icon: Icon(isObscure == false
                            ? Icons.remove_red_eye
                            : Icons.visibility_off),
                      ),
                      controller: confirmPassCont,
                      obscureText: isObscure,
                      isshowPasswordControls: true,
                      isEnabled: true,
                      inputType: TextInputType.visiblePassword,
                      hint: "Confirm Password",
                      onChange: (value) {
                        if (value.isEmpty) {
                          passChangedVal = '';
                        }
                        log("value.length = ${value.trim().length}");
                        log("passChangedVal.length = ${passChangedVal.trim().length}");
                        if (value.trim().length > passChangedVal.length) {
                          passChangedVal = value;
                          checkCaps(capsCont: passCont);
                        }
                      },
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Lock.svg",
                      ),
                    ),
                  if (isConfrimPassError)
                    formErrorText(error: confirmPassErrorString),
                  if (!widget.isReseller)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Already have Account ?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),

                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  DefaultButton(
                      text: "Register",
                      press: () {
                        if (isLoginValidated()) {
                          registerByCustomerBody = {
                            "id": 0,
                            "firstName": fNameCont.text.trim(),
                            "lastName": lNameCont.text.trim(),
                            "salon_Name": salonNameCont.text.trim(),
                            "state": stateCont.text.trim(),
                            "city": cityCont.text.trim(),
                            "address": addressCont.text.trim(),
                            "location": "",
                            "customerImage":
                                imagePath == null ? null : imagePath!,
                            "phone": phoneCont.text.trim(),
                            "saleRepID": widget.isReseller == true ? 1 : 1,
                            "email": emailCont.text.trim(),
                            "password": passCont.text.trim(),
                            "roleId": 0
                          };
                          registerHandler();
                        }
                      }),
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

  void _convertImageToBase64() async {
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        imagePath = base64Image;
        log("selected image path = $imagePath");
      });
    }
  }

  bool isLoginValidated() {
    bool isValid = true;
    isEmailError = false;
    isPassError = false;

    if (fNameCont.text.isEmpty) {
      fNamaeErrorString = "Please enter name";
      isfNamaeError = true;
      isValid = false;
    } else {
      isfNamaeError = false;
    }

    if (lNameCont.text.isEmpty) {
      lNameErrorString = "Please enter last name";
      islNameError = true;
      isValid = false;
    } else {
      islNameError = false;
    }

    if (addressCont.text.isEmpty) {
      addressErrorString = "Please enter Address";
      isAddressError = true;
      isValid = false;
    } else {
      isAddressError = false;
    }

    if (phoneCont.text.characters.length < 12) {
      phoneErrorString = "Please enter phone number";
      isPhoneError = true;
      isValid = false;
    } else {
      isPhoneError = false;
    }

    if (salonNameCont.text.isEmpty) {
      salonNameErrorString = "Please enter saloon name";
      isSalonError = true;
      isValid = false;
    } else {
      isSalonError = false;
    }

    if (stateCont.text.isEmpty) {
      stateNameErrorString = "Please enter state name";
      isStateError = true;
      isValid = false;
    } else {
      isStateError = false;
    }

    if (cityCont.text.isEmpty) {
      cityNameErrorString = "Please enter city name";
      isCityError = true;
      isValid = false;
    } else {
      isCityError = false;
    }

    if (emailCont.text.isEmpty) {
      emailErrorString = "Email is Required";
      isEmailError = true;
      isValid = false;
    } else {
      isEmailError = false;
    }

    if (!emailValidatorRegExp.hasMatch(emailCont.text)) {
      emailErrorString = "Email not valid !";
      isEmailError = true;
      isValid = false;
    } else {
      isEmailError = false;
    }

    if (!widget.isReseller) {
      if (passCont.text.length < 6) {
        passErrorString = "Password cannot be less than 6 characters";
        isPassError = true;
        isValid = false;
      } else {
        isPassError = false;
      }
      if (confirmPassCont.text.length < 6) {
        confirmPassErrorString = "Password not correct";
        isConfrimPassError = true;
        isValid = false;
      } else {
        isConfrimPassError = false;
      }

      if (passCont.text != confirmPassCont.text) {
        confirmPassErrorString = "Password not Matched";
        isConfrimPassError = true;
        isValid = false;
      } else {
        isConfrimPassError = false;
      }
    }

    setState(() {});
    return isValid;
  }

  checkCaps({required TextEditingController capsCont}) {
    _isCapsOn = capsCont.text.isNotEmpty
        ? capsCont.text.characters.last ==
            capsCont.text.characters.last.toUpperCase()
        : false;
    setState(() {});
    if (isLetter(passCont.text.characters.last) && _isCapsOn) {
      CustomSnackBar.showSnackBar(
          context: context,
          message: "Caps lock is on",
          bgColor: Colors.black87);
    }
  }
}
