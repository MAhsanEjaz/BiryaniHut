import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/resseller_customers_model.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/providers/timelines_provider.dart';
import 'package:shop_app/providers/top_category_provider.dart';
import 'package:shop_app/sales%20rep/rep_panel/salesrep_panel_page.dart';
import 'package:shop_app/sales%20rep/salesrep_customers.dart';
import 'package:shop_app/sales%20rep/salesrep_order_page.dart';
import 'package:shop_app/sales%20rep/salesrep_products_page.dart';
import 'package:shop_app/sales%20rep/salesrep_report_page.dart';
import 'package:shop_app/sales%20rep/salesrep_reviews_page.dart';
import 'package:shop_app/sales%20rep/timelines/screens/timelines_page.dart';
import 'package:shop_app/services/salesrep_getprofile_service.dart';
import 'package:shop_app/services/top_category_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';

import '../components/custom_reseller_bottom_nav_bar.dart';
import '../components/reseller_dashbord_vertical_card_widget.dart';
import '../components/reseller_horizntal_dashboard_widget.dart';

class SalesRepDashboardPage extends StatefulWidget {
  const SalesRepDashboardPage({Key? key}) : super(key: key);

  @override
  State<SalesRepDashboardPage> createState() => _SalesRepDashboardPageState();
}

class _SalesRepDashboardPageState extends State<SalesRepDashboardPage> {
  LoginStorage storage = LoginStorage();

  DateTime? _lastPressedTime;

  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    if (_lastPressedTime == null ||
        currentTime.difference(_lastPressedTime!) >
            const Duration(seconds: 1)) {
      _lastPressedTime = currentTime;

      showToast('Double press to exit');

      return false;
    }
    return true;
  }

  Future<void> getSalesrepProfileDataHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesrepProfileDataService().repProfileService(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSalesrepProfileDataHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<SalesrepProfileProvider>(builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.transparent),
            backgroundColor: appColor,
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Home",
                style: appbarTextStye,
              ),
            ),
            // actions: [
            //   IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.notifications_active,
            //         color: whiteColor,
            //       ))
            // ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Welcome ${storage.getUserFirstName()} " +
                  //       storage.getUserLastName(),
                  //   style: welStyle,
                  // ),

                  data.repProfileModel == null
                      ? const CupertinoActivityIndicator()
                      : Text(
                          "Welcome ${data.repProfileModel!.data.firstName} " +
                              data.repProfileModel!.data.lastName,
                          style: welStyle,
                        ),

                  const Text(
                    "Today is perfect day for beginning",
                    style: dayStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<TimeLinesProvider>(builder: (context, data, _) {
                        return ResellerHorizontalDashboardWidget(
                          imageUrl: "assets/icons/timelines_icon.svg",
                          title: "Timeline",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TimelinesPage()));
                          },
                        );
                      }),
                      ResellerHorizontalDashboardWidget(
                        imageUrl: "assets/svg/Orders (2).svg"
                            "",
                        title: "Orders",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SalesrepOrdersPage()));
                        },
                      ),
                      ResellerHorizontalDashboardWidget(
                        imageUrl: "assets/icons/customer_icon.svg",
                        title: "Customers",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResellerCustomersPage()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ResellerDashboardVerticalCardWidget(
                    title: 'Products',
                    imageUrl: "assets/icons/products_icon.svg",
                    subTitle: "Find the perfect item for your needs.",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesRepProductsPage(
                                    customerId: 0,
                                    isReseller: false,
                                  )));
                    },
                  ),
                  // ResellerDashboardVerticalCardWidget(
                  //   title: 'Custom Order',
                  //   imageUrl: "assets/icons/products_icon.svg",
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => ResellerProductsPage()));
                  //   },
                  // ),
                  ResellerDashboardVerticalCardWidget(
                    title: 'Review & Comments',
                    imageUrl: "assets/icons/review_comments_icon.svg",
                    subTitle:
                        "Peruse the feedback and opinions shared by customers",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SalesRepReviewsPage()));
                    },
                  ),
                  ResellerDashboardVerticalCardWidget(
                    imageUrl: "assets/icons/reposts.svg",
                    title: "Reports",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SaleRepReportPage()));
                    },
                    subTitle: 'View Your Reports',
                  ),

                  // ResellerDashboardVerticalCardWidget(
                  //   imageUrl: "assets/icons/reposts.svg",
                  //   title: "Payment Setup",
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const SalesrepPanelPage()));
                  //   },
                  //   subTitle: 'Setup your payment methods',
                  // ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const CustomResellerBottomNavBar(
            selectedMenu: ResellerMenuState.home,
          ),
        );
      }),
    );
  }

  messageToAdminDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Text(
                      "Send Message",
                      style: headingStyle,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      hint: "Enter Message",
                      maxlines: 2,
                      isEnabled: true,
                    ),
                    DefaultButton(
                      text: "Send",
                      verticalMargin: 12.0,
                      width: MediaQuery.of(context).size.width / 2,
                      press: () {},
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
