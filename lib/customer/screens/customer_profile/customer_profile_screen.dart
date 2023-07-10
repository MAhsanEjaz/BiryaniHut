import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/all_cities_model.dart';
import 'package:shop_app/models/states_model.dart';
import 'package:shop_app/providers/all_cities_provider.dart';
import 'package:shop_app/providers/customer_profile_provider.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/providers/states_provider.dart';
import 'package:shop_app/services/customer_get_profile_service.dart';
import 'package:shop_app/services/get_all_cities_service.dart';
import 'package:shop_app/services/get_all_states_services.dart';
import 'package:shop_app/services/phone_format_service.dart';
import 'package:shop_app/services/salesrep_getprofile_service.dart';
import 'package:shop_app/services/update_customer_service.dart';
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
  TextEditingController companyCont = TextEditingController();
  TextEditingController zipCont = TextEditingController();

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
    emailCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .email
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

    companyCont.text =
        Provider.of<CustomerProfileProvider>(context, listen: false)
                .customerProfileModel!
                .data!
                .saleRep!
                .companyName ??
            '';

    zipCont.text = Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel!
            .data!
            .postalCode ??
        '';

    var customerProfile =
        Provider.of<CustomerProfileProvider>(context, listen: false)
            .customerProfileModel;

    if (customerProfile != null &&
        customerProfile.data != null &&
        customerProfile.data!.saleRep != null) {
      salesRepCont.text = (customerProfile.data!.saleRep!.firstName! +
              " " +
              customerProfile.data!.saleRep!.lastName!)
          .toString();
    } else {
      salesRepCont.text = 'Not Assigned yet';
    }
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

    statesName = Provider.of<CustomerProfileProvider>(context, listen: false)
        .customerProfileModel!
        .data!
        .state;
    cityName = Provider.of<CustomerProfileProvider>(context, listen: false)
        .customerProfileModel!
        .data!
        .city;

    CustomLoader.hideLoader(context);
  }

  updateCustomerHandler() async {
    CustomLoader.showLoader(context: context);
    bool res = await UpdateCustomerService().updateCustomerService(
        context: context,
        address: addressCont.text,
        salonName: saloonControl.text,
        email: emailCont.text,
        saleRepImage: imagee,
        postalCode: zipCont.text.trim(),
        companyName: companyCont.text,
        customerId: loginStorage.getUserId(),
        state: statesName,
        city: cityName,
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

    // emailCont.text = loginStorage.getUserEmail();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllStatesHandler();
    });

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

  List<AllStatesModel> statesModel = [];
  List<AllCitiesModel> citiesModel = [];

  getAllCitiesHandler() async {
    CustomLoader.showLoader(context: context);
    await GetAllCitiesService().getAllCitiesService(context: context);

    citiesModel =
        Provider.of<AllCitiesProvider>(context, listen: false).cities!;
    print('cities---->${citiesModel}');
    setState(() {});

    CustomLoader.hideLoader(context);
  }

  getAllStatesHandler() async {
    CustomLoader.showLoader(context: context);
    await GetAllStatesServices().getAllStatesServices(context: context);

    statesModel =
        Provider.of<StatesProvider>(context, listen: false).statesData!;
    print('states---->${statesModel}');
    setState(() {});

    CustomLoader.hideLoader(context);
  }

  String? statesName;
  String? cityName;

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit),
                            SizedBox(width: 5),
                            Text('Edit Profile')
                          ],
                        ),
                        const SizedBox(height: 3),
                        data.customerProfileModel == null
                            ? const CupertinoActivityIndicator(radius: 10)
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Hey there ${data.customerProfileModel!.data!.firstName}!",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.black87),
                                ),
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
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text("Sign out"))),

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
                            headerText: "Company Name",
                            controller: companyCont,
                            isEnabled: false,
                            hint: 'Company Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "State",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 7),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/State Icon (1).svg",
                                        width: 26,
                                        height: 26,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(statesName == null
                                          ? 'Select State'
                                          : statesName!),
                                    ],
                                  ),
                                  items: statesModel.map((e) {
                                    return DropdownMenuItem(
                                        onTap: () {
                                          statesName = e.stateName;

                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            getAllCitiesHandler();
                                          });
                                          setState(() {});
                                        },
                                        value: e.stateName,
                                        child: Text(e.stateName.toString()));
                                  }).toList(),
                                  onChanged: (_) {}),
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "City",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 7),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/City Icon (1).svg",
                                        color: Colors.black45,
                                        width: 26,
                                        height: 26,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(cityName == null
                                          ? 'Select City'
                                          : cityName!),
                                    ],
                                  ),
                                  items: citiesModel.map((e) {
                                    return DropdownMenuItem(
                                        onTap: () {
                                          cityName = e.cityName;
                                          setState(() {});
                                        },
                                        value: e.cityName,
                                        child: Text(e.cityName.toString()));
                                  }).toList(),
                                  onChanged: (_) {}),
                            ),
                          ),
                        ),

                        CustomTextField(
                            headerText: "Zip Code",
                            isEnabled: true,
                            controller: addressCont,
                            hint: "Zip Code",
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
                        Align(
                          alignment: Alignment.center,
                          child: DefaultButton(
                            verticalMargin: 10.0,
                            text: "Update",
                            width: getProportionateScreenWidth(200),
                            press: () {
                              updateCustomerHandler();
                            },
                          ),
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
