import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/sales%20rep/timelines/widgets/orders_widget.dart';
import 'package:shop_app/services/salesrep_orders_service.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../components/reseller_order_status_widget.dart';
import '../models/salesrep_orders_model.dart';
import '../providers/sale_rep_orders_provider.dart';

class SalesrepOrdersPage extends StatefulWidget {
  const SalesrepOrdersPage({Key? key}) : super(key: key);

  @override
  State<SalesrepOrdersPage> createState() => _SalesrepOrdersPageState();
}

class _SalesrepOrdersPageState extends State<SalesrepOrdersPage> {
  int selectedIndex = 0;

  List<SaleRapOrdersList> getSaleOrders = [];
  List<SaleRapOrdersList> searchSaleOrders = [];

  getSaleRepOrdersHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesRepOrdersService().getSaleRepOrders(context: context);

    final searchOrders =
        Provider.of<SaleRepOrdersProvider>(context, listen: false).repOrder;
    getSaleOrders = searchOrders!;
    searchSaleOrders = getSaleOrders;
    log('myOrders--->$searchOrders');

    setState(() {});

    CustomLoader.hideLoader(context);
  }

  onSearchFunction(String? query) {
    final lowerQuery = query!.toLowerCase();

    setState(() {
      getSaleOrders = searchSaleOrders.where((element) {
        final name = element.firstName!.trim().toLowerCase();
        final saloon = element.salonName!.trim().toLowerCase();
        final lastName = element.lastName!.trim().toLowerCase();
        final address = element.address!.trim().toLowerCase();
        final fullName = '$name $lastName';
        final saleRepName = element.saleRepName!.trim().toLowerCase();
        return name.contains(lowerQuery) ||
            saloon.contains(lowerQuery) ||
            lastName.contains(lowerQuery) ||
            address.contains(lowerQuery) ||
            fullName.contains(lowerQuery) ||
            saleRepName.contains(lowerQuery);
      }).toList();
    });
  }

  TextEditingController searchController = TextEditingController();

  onClearFunction() {
    setState(() {
      getSaleOrders = searchSaleOrders;
      searchController.clear();
      setState(() {});
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSaleRepOrdersHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SalesrepOrdeStatusWidget(
                shopStatusText: "Open",
                bgColor: selectedIndex == 0 ? true : false,
                onTap: () {
                  selectedIndex = 0;
                  setState(() {});
                },
                isRep: true,
              ),
              SalesrepOrdeStatusWidget(
                shopStatusText: "Closed",
                bgColor: selectedIndex == 1 ? true : false,
                isRep: true,
                onTap: () {
                  selectedIndex = 1;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: searchController,
                onChange: onSearchFunction,
                hint: 'Search Orders',
                prefixWidget: const Icon(Icons.search),
                suffixWidget: searchController.text.isNotEmpty
                    ? InkWell(
                        onTap: onClearFunction, child: const Icon(Icons.clear))
                    : const SizedBox.shrink(),
              ),
              getSaleOrders.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: getSaleOrders.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return selectedIndex == 0 &&
                                getSaleOrders[index].status == "Pending"
                            ? SaleRepOrderWidget(
                                index: index,
                                isCustomer: false,
                                repOrders: getSaleOrders[index],
                                showBanner: false,
                              )
                            : selectedIndex == 1 &&
                                    getSaleOrders[index].status == "Delivered"
                                ? SaleRepOrderWidget(
                                    index: index,
                                    isCustomer: false,
                                    repOrders: getSaleOrders[index],
                                    showBanner: false,
                                  )
                                : const SizedBox();
                      })
                  : const Center(
                      child: Center(child: Text("No order found")),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class SaleRepOrderWidget extends StatelessWidget {
  SaleRapOrdersList repOrders;
  bool showBanner;
  int index;
  bool isCustomer;

  SaleRepOrderWidget(
      {Key? key,
      required this.repOrders,
      required this.showBanner,
      required this.index,
      required this.isCustomer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showBanner) {
      return Banner(
        message: repOrders.status!,

        color: repOrders.status == "Pending" ? Colors.redAccent : Colors.green,
        // textStyle: TextStyle(color: Colors.black),
        location: BannerLocation.topEnd,
        child: SalesrepOrderWidget2(
          repOrders: repOrders,
          isCustomer: isCustomer,
          index: index,
        ),
      );
    } else {
      return SalesrepOrderWidget2(
        repOrders: repOrders,
        isCustomer: isCustomer,
        index: index,
      );
    }
  }
}
