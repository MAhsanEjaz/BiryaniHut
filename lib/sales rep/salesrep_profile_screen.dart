import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/services/update_custom_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../../../storages/login_storage.dart';
import '../customer/login/login_page.dart';
import '../services/salesrep_getprofile_service.dart';

class SalesrepProfileScreen extends StatefulWidget {
  const SalesrepProfileScreen({Key? key}) : super(key: key);

  @override
  State<SalesrepProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<SalesrepProfileScreen> {
  final image = ImagePicker();

  String? imagePathh;

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();

  TextEditingController saloonControl = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController numberCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  LoginStorage loginStorage = LoginStorage();

  updateCustomerHandler() async {
    CustomLoader.showLoader(context: context);
    bool res = await UpdateCustomService().updateCustomerService(
        isSaleREpProfile: true,
        context: context,
        address: addressCont.text,
        customerId: loginStorage.getUserId(),
        firstName: firstNameCont.text,
        lastName: lastNameCont.text,
        saleRepImage: imagePathh,
        phone: phoneCont.text);

    log(loginStorage.getSalesRepId().toString());

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

  Future<void> getSalesrepProfileDataHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesrepProfileDataService().repProfileService(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    super.initState();

    emailCont.text = loginStorage.getUserEmail();
    firstNameCont.text = loginStorage.getUserFirstName();
    lastNameCont.text = loginStorage.getUserLastName();
    phoneCont.text = loginStorage.getPhone();
    addressCont.text = loginStorage.getAdress();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSalesrepProfileDataHandler();
    });
  }

  File? imagePath;

  void _convertImageToBase64() async {
    if (imagePath != null) {
      List<int> imageBytes = await imagePath!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        imagePathh = base64Image;
        log("selected image path = $imagePathh");
      });
    }
  }

  // Uni bytes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Consumer<SalesrepProfileProvider>(
              builder: (context, data, _) {
                if (data.repProfileModel != null) {
                  emailCont.text = data.repProfileModel!.data.email;
                  firstNameCont.text = data.repProfileModel!.data.firstName;
                  lastNameCont.text = data.repProfileModel!.data.lastName;
                  phoneCont.text = data.repProfileModel!.data.phone;
                  addressCont.text = data.repProfileModel!.data.address;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                            // image: imagePath!.path.isEmpty
                            //     ? const DecorationImage(
                            //         image: AssetImage(
                            //             'assets/images/person.jpg'))
                            //     : DecorationImage(
                            //         image: FileImage(File(imagePath!.path)),
                            //         fit: BoxFit.cover)
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              InkWell(
                                  onTap: () async {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.edit),
                          SizedBox(width: 5),
                          Text('Edit Profile')
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Text(
                      //   "Hey there ${loginStorage.getUserFirstName()} ${loginStorage.getUserLastName()}!",
                      //   style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 24,
                      //       color: Colors.black87),
                      // ),
                      TextButton(
                          onPressed: () {
                            Hive.box("login_hive").clear();
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
                          hint: 'Last Name',
                          hintTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      CustomTextField(
                          headerText: "Email",
                          controller: emailCont,
                          isEnabled: false,
                          hint: 'Email',
                          hintTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      CustomTextField(
                          headerText: "Phone #",
                          isEnabled: true,
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
                        width: MediaQuery.of(context).size.width / 2,
                        verticalMargin: 10.0,
                        text: "Update",
                        press: () {
                          updateCustomerHandler();
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
