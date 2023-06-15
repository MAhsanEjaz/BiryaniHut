import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

import '../../../components/reseller_order_time_calender_widget.dart';
import '../../../models/salesrep_orders_model.dart';
import '../../order_detail_page.dart';
import '../../sales_rep_reports/sale_rep_order_report_details_screen.dart';

class SalesrepOrderWidget2 extends StatelessWidget {
  SalesrepOrderWidget2({
    Key? key,
    required this.repOrders,
    required this.isCustomer,
  }) : super(key: key);

  final SaleRapOrdersList repOrders;
  bool isCustomer;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: repOrders.customerImagePath != "" ||
                    repOrders.customerImagePath != null
                ? CircleAvatar(
                    maxRadius: 28.0,
                    backgroundImage: NetworkImage(repOrders.customerImagePath!))
                : const CircleAvatar(
                    maxRadius: 28.0,
                    backgroundImage:
                        AssetImage('assets/images/Profile Image.png'),
                  ),
            title: Text(
              repOrders.salonName ?? "",
              style: nameStyle,
            ),
            subtitle: Text(repOrders.firstName! + " " + repOrders.lastName!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "\$ ${repOrders.grandTotal!.toStringAsFixed(2)} ",
                ),
                InkWell(
                  onTap: () {
                    log("isCustomer = $isCustomer");
                    log("repOrders.dateTime = ${repOrders.dateTime}");
                    log("repOrders.firstName! = ${repOrders.firstName!}");
                    log("repOrders.lastName! = ${repOrders.lastName!}");
                    log("repOrders.orderId = ${repOrders.orderId}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SaleRepOrderReportDetailsScreen(
                                  phone: repOrders.phone!,
                                  isInvoices: false,
                                  isCustomer: isCustomer,
                                  email: repOrders.email!,
                                  orders: repOrders,
                                  date: repOrders.dateTime!,
                                  name: repOrders.firstName! +
                                      repOrders.lastName!,
                                  orderId: repOrders.orderId!,
                                  key: key,
                                  // showScaffold: true,
                                )));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: appColor,
                      ),
                      child: const Text(
                        "View Details",
                        textAlign: TextAlign.center,
                        style: detStyle,
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(thickness: 1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Address : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: repOrders.address,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ResellerOrderTimeDateWidget(
                        text: getDate(repOrders.dateTime),
                        icon: Icons.calendar_month,
                      ),
                    ),
                    Expanded(
                      child: ResellerOrderTimeDateWidget(
                        text: getTime(repOrders.dateTime),
                        // "${getTime(repOrders.dateTime)}",
                        icon: Icons.access_time,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
