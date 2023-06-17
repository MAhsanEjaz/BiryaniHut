import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/all_orders_provider.dart';
import 'package:shop_app/services/all_orders_service.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../../../components/reseller_order_status_widget.dart';
import '../../../constants.dart';
import '../../../sales rep/salesrep_order_page.dart';

class CustomerOrderHistoryPage extends StatefulWidget {
  const CustomerOrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<CustomerOrderHistoryPage> createState() =>
      _CustomerOrderHistoryPageState();
}

class _CustomerOrderHistoryPageState extends State<CustomerOrderHistoryPage> {
  allOrdersHandler() async {
    CustomLoader.showLoader(context: context);
    await AllOrdersService()
        .getAllOrders(context: context, customerId: LoginStorage().getUserId());
    CustomLoader.hideLoader(context);
  }

  int selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      allOrdersHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        iconTheme: iconTheme,
        title: const Text(
          "Orders History",
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SalesrepOrdeStatusWidget(
                    isRep: false,
                    shopStatusText: "Open",
                    bgColor: selectedIndex == 0 ? true : false,
                    onTap: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                  ),
                  SalesrepOrdeStatusWidget(
                    isRep: false,
                    shopStatusText: "Closed",
                    bgColor: selectedIndex == 1 ? true : false,
                    onTap: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Consumer<AllOrdersProvider>(builder: (context, order, _) {
                if (order.allOrders!.isNotEmpty && order.allOrders != null) {
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: order.allOrders!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return selectedIndex == 0 &&
                                order.allOrders![index].status == "Pending"
                            ? SaleRepOrderWidget(
                                repOrders: order.allOrders![index],
                                showBanner: false,


                                isCustomer: true, index: index,
                              )
                            : selectedIndex == 1 &&
                                    order.allOrders![index].status ==
                                        "Delivered"
                                ? SaleRepOrderWidget(
                                    repOrders: order.allOrders![index],
                                    showBanner: false,
                                    isCustomer: true, index: index,
                                  )
                                : const SizedBox();
                      });
                } else {
                  Container(
                      height: MediaQuery.of(context).size.width / 0.6,
                      alignment: Alignment.center,
                      child: const Text(
                        "No Orders Available against this customer",
                        textAlign: TextAlign.center,
                      ));
                }

                return const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
