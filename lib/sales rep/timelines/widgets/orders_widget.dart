import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

import '../../../components/reseller_order_time_calender_widget.dart';
import '../../../models/salesrep_orders_model.dart';
import '../../sales_rep_reports/sale_rep_order_report_details_screen.dart';

class SalesrepOrderWidget2 extends StatefulWidget {
  SalesrepOrderWidget2(
      {Key? key,
      required this.repOrders,
      required this.index,
      required this.isCustomer})
      : super(key: key);

  final SaleRapOrdersList repOrders;
  int index;
  bool isCustomer;

  @override
  State<SalesrepOrderWidget2> createState() => _SalesrepOrderWidget2State();
}

class _SalesrepOrderWidget2State extends State<SalesrepOrderWidget2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
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
              leading: widget.repOrders.customerImagePath != "" ||
                      widget.repOrders.customerImagePath != null
                  ? CircleAvatar(
                      maxRadius: 28.0,
                      backgroundImage:
                          NetworkImage(widget.repOrders.customerImagePath!))
                  : const CircleAvatar(
                      maxRadius: 28.0,
                      backgroundImage:
                          AssetImage('assets/images/Profile Image.png'),
                    ),
              title: Text(
                widget.repOrders.salonName ?? "",
                style: nameStyle,
              ),
              subtitle: Text(widget.repOrders.firstName! +
                  " " +
                  widget.repOrders.lastName!),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\$ ${widget.repOrders.grandTotal!.toStringAsFixed(2)} ",
                  ),
                  InkWell(
                    onTap: () {
                      log("isCustomer = ${widget.isCustomer}");
                      log("repOrders.dateTime = ${widget.repOrders.dateTime}");
                      log("repOrders.firstName! = ${widget.repOrders.firstName!}");
                      log("repOrders.lastName! = ${widget.repOrders.lastName!}");
                      log("repOrders.orderId = ${widget.repOrders.orderId}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SaleRepOrderReportDetailsScreen(
                                    phone: widget.repOrders.phone ??
                                        '${widget.repOrders.phone}',
                                    isInvoices: false,
                                    isCustomer: widget.isCustomer,
                                    email: widget.repOrders.email ??
                                        '${widget.repOrders.email}',
                                    orders: widget.repOrders,
                                    date: widget.repOrders.dateTime!,
                                    name: widget.repOrders.firstName! +
                                        widget.repOrders.lastName!,
                                    orderId: widget.repOrders.orderId!,
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
                            text: widget.repOrders.address,
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
                          text: getDate(widget.repOrders.dateTime),
                          icon: Icons.calendar_month,
                        ),
                      ),
                      Expanded(
                        child: ResellerOrderTimeDateWidget(
                          text: getTime(widget.repOrders.dateTime),
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
      ),
    );
  }
}
