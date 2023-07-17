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
import 'package:shop_app/helper/custom_snackbar.dart';
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

class _CustomerProfileScreenState extends State<CustomerProfileScreen>
    with TickerProviderStateMixin {
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customerGetDataHandler();
    });

    // emailCont.text = loginStorage.getUserEmail();
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

  getAllStatesHandler(String cityName) async {
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

  AnimationController? _controller;
  Animation<double>? _animation;
  bool expand = false;
  bool showSearchData = false;

  String? statesName;
  String? cityName;
  String? selectCityName;

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
                            headerText: "SaleRep Company Name",
                            controller: companyCont,
                            isEnabled: false,
                            hint: 'Company Name',
                            hintTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Text(
                            "Select City",
                            style: titleStyle,
                          ),
                        ),
                        SizedBox(height: 5),

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
                                      parent: _controller!,
                                      curve: Curves.easeInExpo);

                                  // Define the animation values (e.g., from 0.0 to 1.0)
                                  _animation =
                                      Tween<double>(begin: 0.0, end: 1.0)
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
                                                  ? 'Select Cities'
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child:
                                                              CupertinoTextField(
                                                                  controller:
                                                                      controller,
                                                                  placeholder:
                                                                      'Search Cities',
                                                                  onSubmitted:
                                                                      (v) {
                                                                    WidgetsBinding
                                                                        .instance
                                                                        .addPostFrameCallback(
                                                                            (timeStamp) {
                                                                      controller.text.length <
                                                                              3
                                                                          ? CustomSnackBar.failedSnackBar(
                                                                              context: context,
                                                                              message: 'Text should be at least 3 characters long')
                                                                          : citiesHandler(v);
                                                                      showSearchData =
                                                                          true;

                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  }),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        showSearchData == true
                                                            ? cityModel.isEmpty
                                                                ? const Center(
                                                                    child:
                                                                        Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        ('City not found')),
                                                                  ))
                                                                : ListView
                                                                    .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            cityModel
                                                                                .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              cityName = cityModel[index].cityName;
                                                                              selectCityName = cityModel[index].cityName;
                                                                              // model = cities;
                                                                              expand = !expand;

                                                                              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                                                getAllStatesHandler(cityName!);
                                                                              });

                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                                                              child: Text(
                                                                                cityModel[index].cityName!,
                                                                                style: const TextStyle(fontSize: 16),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Text(
                            "Select State",
                            style: titleStyle,
                          ),
                        ),

                        SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            height: 45.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, left: 10),
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
                                      Text(selectCityName != null
                                          ? 'Select'
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
                                          selectCityName = null;

                                          setState(() {});
                                        },
                                        value: e,
                                        child: Text(e.stateName!));
                                  }).toList(),
                                  onChanged: (_) {}),
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        CustomTextField(
                            headerText: "Zip Code",
                            isEnabled: true,
                            controller: zipCont,
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
