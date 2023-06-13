import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/salesrep_customers_widget.dart';
import 'package:shop_app/customer/register/register_page.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/salesrep_get_discount_model.dart';
import 'package:shop_app/providers/reseller_customer_provider.dart';
import 'package:shop_app/providers/salesrep_discount_provider.dart';
import 'package:shop_app/services/get_salesrep_discount_service.dart';
import 'package:shop_app/services/reseller_customers_service.dart';
import 'package:shop_app/services/salesrep_getprofile_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../constants.dart';
import '../models/resseller_customers_model.dart';
import '../providers/salesrep_profile_provider.dart';

class ResellerCustomersPage extends StatefulWidget {
  const ResellerCustomersPage({Key? key}) : super(key: key);

  @override
  State<ResellerCustomersPage> createState() => _ResellerCustomersPageState();
}

class _ResellerCustomersPageState extends State<ResellerCustomersPage> {
  int selectedIndex = 0;
  final searchCont = TextEditingController();
  FocusNode searchFocus = FocusNode();

  getResellerCustomerHandler() async {
    CustomLoader.showLoader(context: context);
    await ResellerCustomerService()
        .getCustomerList(context: context, isReport: false);
    final myProvider =
        Provider.of<ResellerCustomerProvider>(context, listen: false);
    searchList = myProvider.custList!;

    print('myList---->$searchList');

    customerProvider = searchList;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  List<SalesrepCustomerData> searchList = [];
  List<SalesrepCustomerData> customerProvider = [];

  // String query = '';

  void filterList(String query) async {
    final queryLower = query.toLowerCase();
    await ResellerCustomerService()
        .getCustomerList(context: context, isReport: false);
    setState(() {
      searchList = customerProvider.where((element) {
        final saloonName = element.salonName!.trim().toLowerCase();
        final firstName = element.firstName!.trim().toLowerCase();
        final lastName = element.lastName!.trim().toLowerCase();
        final fullName = '$firstName $lastName';

        return saloonName.contains(queryLower) || fullName.contains(queryLower);
      }).toList();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getResellerCustomerHandler();
    });

    super.initState();
  }

  SalesrepDiscountModel? discountModel;

  bool showSellerList = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ResellerCustomerProvider>(builder: (context, customer, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    String discount = "not assigned";
                    await getRepDiscountHandler();
                    //  Provider.of<CartCounterProvider>(context, listen: false)

                    showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Discounts'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Discount is = $discount"),
                              Row(
                                children: [
                                  ToggleSwitch(
                                    animate: true,
                                    activeBgColor: const [appColor, appColor],
                                    changeOnTap: true,
                                    initialLabelIndex: selectedIndex,
                                    totalSwitches: 2,
                                    centerText: true,
                                    minWidth:
                                        MediaQuery.of(context).size.width / 3.2,
                                    labels: const [
                                      'Discount in Dollers',
                                      'Percentage'
                                    ],
                                    onToggle: (val) {
                                      setState(() {
                                        selectedIndex = val!;
                                      });
                                      print(selectedIndex);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (selectedIndex == 0)
                                CustomTextField(
                                  prefixWidget:
                                      const Icon(CupertinoIcons.money_dollar),
                                  inputType: TextInputType.number,
                                ),
                              if (selectedIndex == 1)
                                CustomTextField(
                                  prefixWidget:
                                      const Icon(CupertinoIcons.percent),
                                  inputType: TextInputType.number,
                                ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Save'),
                                style:
                                    ElevatedButton.styleFrom(primary: appColor),
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  },
                  child: const Text(
                    'Add Discounts',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor,
                    elevation: 10,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              )
            ],
            backgroundColor: appColor,
            iconTheme: iconTheme,
            title: const Text(
              "Customers",
              style: appbarTextStye,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                      onChange: filterList,
                      controller: searchCont,
                      focusNode: searchFocus,
                      hint: "Search customer",
                      prefixWidget: const Icon(Icons.search),
                      isEnabled: true,
                      suffixWidget: searchCont.text.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                searchCont.clear();
                                setState(() {
                                  searchList = customerProvider;
                                });
                              },
                              icon: const Icon(Icons.close))
                          : const SizedBox()),
                ),
                if (searchList.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final originalIndex = searchList[index];
                        TextEditingController firstNameController =
                            TextEditingController(
                          text: originalIndex.firstName?.toString() ?? '',
                        );
                        TextEditingController lastNameController =
                            TextEditingController(
                          text: originalIndex.lastName?.toString() ?? '',
                        );

                        TextEditingController saloonNameController =
                            TextEditingController(
                          text: originalIndex.salonName?.toString() ?? '',
                        );

                        TextEditingController addressController =
                            TextEditingController(
                          text: originalIndex.phone?.toString() ?? '',
                        );

                        TextEditingController phoneController =
                            TextEditingController(
                          text: originalIndex.address?.toString() ?? '',
                        );
                        TextEditingController emailController =
                            TextEditingController(
                          text: originalIndex.email?.toString() ?? '',
                        );

                        TextEditingController saloonController =
                            TextEditingController(
                          text: originalIndex.salonName?.toString() ?? '',
                        );

                        return SalesRepCustomersWidget(
                          address: addressController,
                          firstName: firstNameController,
                          customers: originalIndex,
                          context: context,
                          phone: phoneController,
                          lastName: lastNameController,
                          solonName: saloonNameController,
                          email: emailController,
                          saloonName: saloonController,
                        );
                      })
                else if (searchCont.text.isNotEmpty && searchList.isEmpty)
                  const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("No Customer matched"))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: appColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SignUpPage(
                  isReseller: true,
                );
              }));
            },
            child: const Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ),
      );
    });
  }

  validateSearch() {
    if (searchCont.text.isEmpty) {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Write something to search");
      searchFocus.requestFocus();
      return false;
    } else {
      return true;
    }
  }

  Future<void> getRepDiscountHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesrepGetDiscountService().getRepDiscount(context: context);
    discountModel =
        Provider.of<SalesrepDiscountProvider>(context, listen: false)
            .repDiscountModel!;
    CustomLoader.hideLoader(context);
  }
}
