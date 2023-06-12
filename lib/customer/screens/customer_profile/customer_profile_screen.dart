import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/customer_profile_provider.dart';
import 'package:shop_app/services/customer_get_profile_service.dart';
import 'package:shop_app/services/phone_format_service.dart';
import 'package:shop_app/services/update_custom_service.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/custom_textfield.dart';

import '../../../storages/login_storage.dart';
import '../../login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final image = ImagePicker();

  File? imagePath;

  Future saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
  }

  Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController saloonControl = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController numberCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController salesRepCont = TextEditingController();

  LoginStorage loginStorage = LoginStorage();

  customerGetDataHandler() async {
    CustomLoader.showLoader(context: context);
    await CustomerGetService()
        .customerGetService(context: context, id: loginStorage.getUserId());

    firstNameCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .firstName
            .toString();

    saloonControl.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .salonName
            .toString();

    lastNameCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .lastName
            .toString();
    salesRepCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
                .customerProfileModel!
                .data!
                .saleRep ??
            '';
    phoneCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .phone!;
    phoneCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .phone!;
    addressCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .address!;

    CustomLoader.hideLoader(context);
  }

  updateCustomerHandler() async {
    CustomLoader.showLoader(context: context);
    bool res = await UpdateCustomService().updateCustomerService(
        context: context,
        address: addressCont.text,
        salonName: saloonControl.text,
        email: emailCont.text,
        saleRepImage: imagee,
        customerId: loginStorage.getUserId(),
        firstName: firstNameCont.text,
        lastName: lastNameCont.text,
        phone: phoneCont.text);

    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Update Successfully'),
        backgroundColor: Colors.green[600],
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error'),
        backgroundColor: Colors.red,
      ));
    }

    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    super.initState();

    emailCont.text = loginStorage.getUserEmail();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customerGetDataHandler();
    });
  }

  String? imagee;

  void _convertImageToBase64() async {
    if (imagePath != null) {
      List<int> imageBytes = await imagePath!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        imagee = base64Image;
        log("selected image path = $imagee");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProfileProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appColor,
        ),
        body: data.customerProfileModel == null
            ? const Center(child: CupertinoActivityIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: imagePath == null
                                    ? null
                                    : data.customerProfileModel!.data!
                                            .customerImagePath!.isEmpty
                                        ? Colors.grey
                                        : Colors.transparent,
                                image: imagePath != null
                                    ? DecorationImage(
                                        image: FileImage(imagePath!),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: NetworkImage(data
                                            .customerProfileModel!
                                            .data!
                                            .customerImagePath
                                            .toString()),
                                        fit: BoxFit.cover)),
                            child: Column(
                              children: [
                                const Spacer(),
                                InkWell(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();

                                      final camImage = await image.pickImage(
                                          source: ImageSource.gallery);
                                      if (camImage != null) {
                                        imagePath = File(camImage.path);
                                        _convertImageToBase64();
                                        setState(() {});
                                      }
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 5),
                            Text('Edit Profile')
                          ],
                        ),
                        const SizedBox(height: 3),
                        data.customerProfileModel == null
                            ? const CupertinoActivityIndicator(radius: 10)
                            : Text(
                                "Hey there ${data.customerProfileModel!.data!.firstName}!",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black87),
                              ),
                        TextButton(
                            onPressed: () {
                              Hive.box("login_hive").clear();
                              Hive.box("customer_cart_box").clear();
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return LoginPage();
                              // }));

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (Route route) => false);
                            },
                            child: const Text("Sign out")),

                        CustomTextField(
                            headerText: "First Name",
                            controller: firstNameCont,
                            isEnabled: true,
                            hint: 'Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),

                        CustomTextField(
                            headerText: "Last Name",
                            controller: lastNameCont,
                            isEnabled: true,
                            hint: 'Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),

                        CustomTextField(
                            headerText: "Salon Name",
                            controller: saloonControl,
                            isEnabled: true,
                            hint: 'Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        CustomTextField(
                            headerText: "Sale Rep Name",
                            controller: salesRepCont,
                            isEnabled: false,
                            hint: 'Sales rep Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        // CustomTextField(
                        //     isEnabled: true,
                        //     hint: 'Saloon',
                        //     hintTextStyle: TextStyle(fontWeight: FontWeight.bold)),
                        CustomTextField(
                            headerText: "Email",
                            controller: emailCont,
                            // isEnabled: false,
                            hint: 'Email',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        CustomTextField(
                            headerText: "Phone # ",
                            isEnabled: true,
                            inputFormats: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(12),
                              PhoneInputFormatter()
                            ],
                            inputType: TextInputType.phone,
                            controller: phoneCont,
                            hint: 'Phone #',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        CustomTextField(
                            headerText: "Address",
                            isEnabled: true,
                            controller: addressCont,
                            hint: "Address",
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        DefaultButton(
                          verticalMargin: 10.0,
                          text: "Update",
                          width: getProportionateScreenWidth(200),
                          press: () {
                            updateCustomerHandler();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
