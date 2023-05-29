import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/sales%20rep/salesrep_order_page.dart';
import 'package:shop_app/size_config.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../constants.dart';
import '../models/salesrep_orders_model.dart';
import '../providers/all_orders_provider.dart';
import '../services/all_orders_service.dart';

class AllOrdersScreen extends StatefulWidget {
  final int customerId;
  const AllOrdersScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  allOrdersHandler() async {
    CustomLoader.showLoader(context: context);
    await AllOrdersService()
        .getAllOrders(context: context, customerId: widget.customerId);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      allOrdersHandler();
    });
    super.initState();
  }

  int filterIndex = 0;
  List<SaleRapOrdersList> todayOrdersList = [];
  List<SaleRapOrdersList> pendingOrdersList = [];
  List<SaleRapOrdersList> completedOrdersList = [];
  List<SaleRapOrdersList> finalList = [];
  List<SaleRapOrdersList> allOrdersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          "All Orders",
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ToggleSwitch(
                  minWidth: SizeConfig.screenWidth,
                  minHeight: 50.0,
                  fontSize: 16.0,
                  animate: true,
                  // doubleTapDisable: true,
                  customWidths: [
                    getProportionateScreenWidth(60),
                    getProportionateScreenWidth(70),
                    getProportionateScreenWidth(90),
                    getProportionateScreenWidth(110)
                  ],
                  initialLabelIndex: filterIndex,
                  activeBgColor: const [appColor],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 4,
                  labels: const ['All', 'Today', 'Pending', "Completed"],
                  onToggle: (index) {
                    // todayOrdersList.clear();
                    pendingOrdersList.clear();
                    completedOrdersList.clear();
                    // finalList.clear();
                    // allOrdersList .clear();

                    log('switched to: $index');
                    filterIndex = index!;
                    if (filterIndex == 1 && todayOrdersList.isEmpty) {
                      // todayOrdersList.clear();

                      DateTime date = DateTime.now();
                      allOrdersList.forEach((element) {
                        if (DateUtils.isSameDay(
                            date, DateTime.parse(element.dateTime!))) {
                          todayOrdersList.add(element);
                        }
                      });
                    } else if (filterIndex == 2 && pendingOrdersList.isEmpty) {
                      allOrdersList.forEach((element) {
                        if (element.status == "Pending") {
                          pendingOrdersList.add(element);
                        } else {
                          completedOrdersList.add(element);
                        }
                      });
                    } else if (filterIndex == 3 &&
                        completedOrdersList.isEmpty) {
                      allOrdersList.forEach((element) {
                        if (element.status == "Pending") {
                          pendingOrdersList.add(element);
                        } else {
                          completedOrdersList.add(element);
                        }
                      });
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AllOrdersProvider>(builder: (context, order, _) {
                  if (order.allOrders!.isNotEmpty && order.allOrders != null) {
                    allOrdersList = order.allOrders!;
                    if (filterIndex == 0) {
                      finalList = allOrdersList;
                    } else if (filterIndex == 1) {
                      finalList = todayOrdersList;
                    } else if (filterIndex == 2) {
                      finalList = pendingOrdersList;
                    } else if (filterIndex == 3) {
                      finalList = completedOrdersList;
                    }
                    log("final list length = ${finalList.length}");
                    log("filterIndex = $filterIndex");

                    return ListView.builder(
                        itemCount: finalList.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return SaleRepOrderWidget(
                            repOrders: finalList[index],
                            showBanner: true,
                          );
                        });
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.width / 0.6,
                        alignment: Alignment.center,
                        child: const Text(
                          "No Orders Available against this customer",
                          textAlign: TextAlign.center,
                        ));
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
