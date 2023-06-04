import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/salesrep_customers_widget.dart';
import 'package:shop_app/customer/register/register_page.dart';
import 'package:shop_app/customer/services/customer_delete_service.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/providers/reseller_customer_provider.dart';
import 'package:shop_app/services/reseller_customers_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../constants.dart';
import '../models/resseller_customers_model.dart';

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

                        return SalesRepCustomersWidget(
                          address: addressController,
                          firstName: firstNameController,
                          customers: originalIndex,
                          context: context,
                          phone: phoneController,
                          lastName: lastNameController,
                          solonName: saloonNameController,
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
          context: context, message: "Search Field is Empty");
      searchFocus.requestFocus();
      return false;
    } else {
      return true;
    }
  }
}
