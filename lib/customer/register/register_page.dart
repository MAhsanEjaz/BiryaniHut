import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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
import 'package:shop_app/models/all_cities_model.dart';
import 'package:shop_app/models/states_model.dart';
import 'package:shop_app/providers/all_cities_provider.dart';
import 'package:shop_app/providers/regitration_provider.dart';
import 'package:shop_app/providers/states_provider.dart';
import 'package:shop_app/services/get_all_cities_service.dart';
import 'package:shop_app/services/get_all_states_services.dart';
import 'package:shop_app/services/phone_format_service.dart';
import 'package:shop_app/services/register_service.dart';
import 'package:shop_app/services/reseller_customers_service.dart';
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

class _SignUpScreenState extends State<SignUpPage>
    with TickerProviderStateMixin {
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
  final zipCont = TextEditingController();

  bool isEmailError = false;
  bool isfNameError = false;
  bool islNameError = false;
  bool isPassError = false;
  bool isAddressError = false;
  bool isPhoneError = false;
  bool isConfirmPassError = false;
  bool isSalonError = false;
  bool isStateError = false;
  bool isCityError = false;
  bool isZipCodeError = false;

  String emailErrorString = '';
  String passErrorString = '';
  String fNameErrorString = '';
  String lNameErrorString = '';
  String phoneErrorString = '';
  String addressErrorString = '';
  String confirmPassErrorString = '';
  String salonNameErrorString = '';
  String stateNameErrorString = '';
  String cityNameErrorString = '';
  String zipCodeErrorString = '';

  Map<String, dynamic> registerByCustomerBody = {};

  Map<String, dynamic> registerBySalesRapBody = {};

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

  // bool _isCapsOn = false;

  File? _image;

  final image = ImagePicker();

  String? imagePath;
  String passChangedVal = '';

  // getResellerCustomerHandler() async {
  //   CustomLoader.showLoader(context: context);
  //   await ResellerCustomerService()
  //       .getCustomerList(context: context, isReport: false);
  //   CustomLoader.hideLoader(context);
  // }

  AnimationController? _controller;
  Animation<double>? _animation;
  bool expand = false;
  bool showSearchData = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // getResellerCustomerHandler();
    });

    phoneCont.addListener(() {
      setState(() {});
    });
  }

  LoginStorage loginStorage = LoginStorage();

  List<AllStatesModel> statesModel = [];

  List<AllCitiesModel> cityModel = [];

  citiesHandler(String? cityName) async {
    CustomLoader.showLoader(context: context);

    await GetAllCitiesService()
        .getAllCitiesService(context: context, cityName: cityName!);
    CustomLoader.hideLoader(context);
    cityModel = Provider.of<AllCitiesProvider>(context, listen: false).cities!;

    print(cityModel);
    setState(() {});
  }

  void getAllStatesHandler() async {
    CustomLoader.showLoader(context: context);
    await GetAllStatesServices()
        .getAllStatesServices(context: context, cityName: cityName);

    statesModel =
        Provider.of<StatesProvider>(context, listen: false).statesData!;
    print('states---->$statesModel');
    setState(() {});

    CustomLoader.hideLoader(context);
  }

  TextEditingController controller = TextEditingController();

  String? statesName;
  String? cityName;

  // String? selectedName;

  @override
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
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _image!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Positioned(
                        right: .3,
                        top: -.2,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text('Camera'),
                                          leading: const Icon(Icons.camera_alt),
                                          onTap: () async {
                                            final camImage =
                                                await image.pickImage(
                                                    source: ImageSource.camera);
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
                              : Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: appColor),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
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
                  if (isfNameError) formErrorText(error: fNameErrorString),

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

                  // if (isStateError) formErrorText(error: stateNameErrorString),

                  // if (isCityError) formErrorText(error: cityNameErrorString),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15),
                        //     side: BorderSide(
                        //         color: expand == true
                        //             ? Colors.black26
                        //             : Colors.transparent)),
                        // elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            expand = !expand;
                            _controller = AnimationController(
                                duration: const Duration(seconds: 1),
                                vsync: this);
                            // Define the animation curve
                            final curvedAnimation = CurvedAnimation(
                                parent: _controller!, curve: Curves.easeInExpo);

                            // Define the animation values (e.g., from 0.0 to 1.0)
                            _animation = Tween<double>(begin: 0.0, end: 1.0)
                                .animate(curvedAnimation);
                            _controller!.forward();
                            setState(() {});
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 12),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/City Icon (1).svg",
                                        height: 23,
                                        width: 23,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        cityName == null
                                            ? 'Select City'
                                            : cityName!,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Icon(expand == true
                                          ? Icons.arrow_drop_up_outlined
                                          : Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                                expand == true
                                    ? AnimatedBuilder(
                                        animation: _animation!,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Opacity(
                                            opacity: _animation!.value,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: CupertinoTextField(
                                                        controller: controller,
                                                        placeholder:
                                                            'Search Cities',
                                                        onSubmitted: (v) {
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (timeStamp) {
                                                            controller.text
                                                                        .length <
                                                                    3
                                                                ? CustomSnackBar
                                                                    .failedSnackBar(
                                                                        context:
                                                                            context,
                                                                        message:
                                                                            'Text should be at least 3 characters long')
                                                                : citiesHandler(
                                                                    v);
                                                            showSearchData =
                                                                true;

                                                            setState(() {});
                                                          });
                                                        }),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  showSearchData == true
                                                      ? cityModel.isEmpty
                                                          ? const Center(
                                                              child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  ('City not found')),
                                                            ))
                                                          : ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  cityModel
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    cityName = cityModel[
                                                                            index]
                                                                        .cityName;
                                                                    // model = cities;
                                                                    expand =
                                                                        !expand;

                                                                    WidgetsBinding
                                                                        .instance
                                                                        .addPostFrameCallback(
                                                                            (timeStamp) {
                                                                      getAllStatesHandler();
                                                                    });

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20.0,
                                                                        vertical:
                                                                            10),
                                                                    child: Text(
                                                                      cityModel[
                                                                              index]
                                                                          .cityName!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      height: 45.0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10),
                        child: DropdownButton(
                            hint: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/State Icon (1).svg",
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.centerLeft,
                                ),
                                const SizedBox(width: 13),
                                Text(statesName == null
                                    ? 'Select Sate'
                                    : statesName!),
                              ],
                            ),
                            underline: const SizedBox(),
                            // padding: const EdgeInsets.all(0),
                            isExpanded: true,
                            items: statesModel.map((e) {
                              return DropdownMenuItem(
                                  onTap: () {
                                    statesName = e.stateName;
                                    setState(() {});
                                  },
                                  value: e,
                                  child: Text(e.stateName!));
                            }).toList(),
                            onChanged: (_) {}),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                      controller: zipCont,
                      isEnabled: true,
                      obscureText: false,
                      isshowPasswordControls: false,
                      hint: "Zip Code",
                      inputType: TextInputType.number,
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Mail.svg",
                        //! change its icon for zipcode
                      )),

                  if (isZipCodeError) formErrorText(error: zipCodeErrorString),

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
                          // checkCaps(capsCont: passCont);
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
                          // checkCaps(capsCont: passCont);
                        }
                      },
                      prefixWidget: SvgPicture.asset(
                        "assets/icons/Lock.svg",
                      ),
                    ),
                  if (isConfirmPassError)
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
                        log("Register clicked");
                        if (isLoginValidated()) {
                          registerByCustomerBody = {
                            "id": 0,
                            "firstName": fNameCont.text.trim(),
                            "lastName": lNameCont.text.trim(),
                            "salon_Name": salonNameCont.text.trim(),
                            "state": stateCont.text.trim(),
                            "postalCode": zipCont.text.trim(),
                            "city": cityName,
                            "address": addressCont.text.trim(),
                            "location": "",
                            "customerImage":
                                imagePath == null ? null : imagePath!,
                            "phone": phoneCont.text.trim(),
                            "saleRepID": widget.isReseller == true
                                ? loginStorage.getUserId()
                                : 1,
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
      fNameErrorString = "Please enter First Name";
      isfNameError = true;
      isValid = false;
    } else {
      isfNameError = false;
    }

    if (lNameCont.text.isEmpty) {
      lNameErrorString = "Please enter Last Name";
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
      phoneErrorString = "Please enter valid phone #";
      isPhoneError = true;
      isValid = false;
    } else {
      isPhoneError = false;
    }

    if (salonNameCont.text.isEmpty) {
      salonNameErrorString = "Please enter Saloon Name";
      isSalonError = true;
      isValid = false;
    } else {
      isSalonError = false;
    }

    if (statesName == null) {
      stateNameErrorString = "Please select State Name";
      isStateError = true;
      isValid = false;
    } else {
      isStateError = false;
    }

    if (cityName == null) {
      cityNameErrorString = "Please Select City Name";
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
        confirmPassErrorString = "Confirm Password not matched";
        isConfirmPassError = true;
        isValid = false;
      } else {
        isConfirmPassError = false;
      }

      if (passCont.text != confirmPassCont.text) {
        confirmPassErrorString = "Password not Matched";
        isConfirmPassError = true;
        isValid = false;
      } else {
        isConfirmPassError = false;
      }
    }

    setState(() {});
    return isValid;
  }

// checkCaps({required TextEditingController capsCont}) {
//   _isCapsOn = capsCont.text.isNotEmpty
//       ? capsCont.text.characters.last ==
//           capsCont.text.characters.last.toUpperCase()
//       : false;
//   setState(() {});
//   if (isLetter(passCont.text.characters.last) && _isCapsOn) {
//     CustomSnackBar.showSnackBar(
//         context: context,
//         message: "Caps lock is on",
//         bgColor: Colors.black87);
//   }
// }
}
