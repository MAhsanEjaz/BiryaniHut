import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/salesrep_orders_model.dart';
import 'package:shop_app/models/salesrep_profile_model.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/services/update_customer_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../../../storages/login_storage.dart';
import '../customer/login/login_page.dart';
import '../services/phone_format_service.dart';
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
  TextEditingController companyCont = TextEditingController();

  LoginStorage loginStorage = LoginStorage();

  updateCustomerHandler() async {
    CustomLoader.showLoader(context: context);
    bool res = await UpdateCustomerService().updateCustomerService(
        isSaleREpProfile: true,
        context: context,
        email: emailCont.text,
        salonName: 'saloonControl.text',
        companyName: companyCont.text,
        address: addressCont.text,
        customerId: loginStorage.getUserId(),
        firstName: firstNameCont.text,
        lastName: lastNameCont.text,
        saleRepImage: imagePathh,
        phone: phoneCont.text);

    getSalesrepProfileDataHandler();

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
    companyCont.text =
        Provider.of<SalesrepProfileProvider>(context, listen: false)
            .repProfileModel!
            .data
            .companyName;
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
        actions: [NavigatorWidget()],
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
                              image:
                                  data.repProfileModel!.data.saleRepImagePath ==
                                          null
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/person.jpg'),
                                          fit: BoxFit.cover)
                                      : imagePath != null
                                          ? DecorationImage(
                                              image: FileImage(imagePath!),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: NetworkImage(data
                                                  .repProfileModel!
                                                  .data
                                                  .saleRepImagePath),
                                              fit: BoxFit.cover)),
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
                            Provider.of<SaleRepOrdersProvider>(context,
                                    listen: false)
                                .repOrder!
                                .clear();

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
                          hint: 'Email',
                          hintTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      CustomTextField(
                          headerText: "Company Name",
                          controller: companyCont,
                          hint: 'Company Name',
                          hintTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      CustomTextField(
                          headerText: "Phone #",
                          isEnabled: true,
                          inputFormats: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                            PhoneInputFormatter(),
                          ],
                          controller: phoneCont,
                          hint: 'Phone #',
                          inputType: TextInputType.phone,
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
