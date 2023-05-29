// import 'package:dropdown_search/dropdown_search.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/salesrep_orders_model.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/sale_rep_order_report_details_screen.dart';

import 'package:shop_app/sales%20rep/order_detail_page.dart';
import 'package:shop_app/services/salesrep_orders_service.dart';
import '../../constants.dart';
import '../../models/resseller_customers_model.dart';
import '../../providers/all_orders_provider.dart';
import '../../providers/reseller_customer_provider.dart';
import '../../providers/sale_rep_orders_provider.dart';
import '../../services/all_orders_service.dart';
import '../../services/reseller_customers_service.dart';
import '../../size_config.dart';
import 'order_report_pdf_screen.dart';

class OrderReportPage extends StatefulWidget {
  const OrderReportPage({Key? key}) : super(key: key);

  @override
  _OrderReportPageState createState() => _OrderReportPageState();
}

class _OrderReportPageState extends State<OrderReportPage> {
  List<SaleRapOrdersList> repOrder = [];
  List<SaleRapOrdersList> orders = [];

  orderHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesRepOrdersService().getSaleRepOrders(context: context);
    setState(() {});
    repOrder =
        Provider.of<SaleRepOrdersProvider>(context, listen: false).repOrder!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  getallOrdersOfCustomerHandler(int customerId) async {
    CustomLoader.showLoader(context: context);
    await AllOrdersService()
        .getAllOrders(context: context, customerId: customerId);
    setState(() {});
    orders = Provider.of<AllOrdersProvider>(context, listen: false).allOrders!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  List<SalesrepCustomerData> resellerList = [];

  getResellerCustomerListHandler() async {
    CustomLoader.showLoader(context: context);
    await ResellerCustomerService()
        .getCustomerList(context: context, isReport: false);
    resellerList =
        Provider.of<ResellerCustomerProvider>(context, listen: false).custList!;
    setState(() {});
    CustomLoader.hideLoader(context);
    // ResellerCustomerProvider
  }

  int? selectedCustomerName;
  String? selectedCustomerId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      orderHandler();
      getResellerCustomerListHandler();
      // getallOrdersOfCustomerHandler();
    });
    super.initState();
  }

  bool showList = false;
  List pending = [];
  List complete = [];
  List<SalesrepCustomerData> custList = [];

  OrderPdfInvoiceService pdfInvoice = OrderPdfInvoiceService();

  @override
  Widget build(BuildContext context) {
    pending.clear();
    complete.clear();
    repOrder.forEach((element) {
      if (element.status == "Pending") {
        pending.add(element);
      } else {
        complete.add(element);
      }
    });
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          'Customers Wise Order Status Report',
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: selectedCustomerName,
                            hint: const Text(
                              "Select Customer",
                            ),
                            items: resellerList.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                    item.firstName! + " " + item.lastName!),
                                value: item.id,
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              if (value == 1084) {
                                selectedCustomerName = value;
                                showList = false;
                                print("Value $value");
                                orderHandler();
                              } else {
                                selectedCustomerName = value;
                                print("value1 $value");
                                showList = true;
                                getallOrdersOfCustomerHandler(
                                    selectedCustomerName!);
                              }
                            }),
                      ),
                    ),
                    const Text(
                      "Orders Report",
                      style: detailsStyle,
                    ),
                    divider(),
                    showList == false
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Orders",
                                    style: orderStyle,
                                  ),
                                  Text(
                                    "${repOrder.length}",
                                    style: orderStyle,
                                  )
                                ],
                              ),
                              divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pending Orders", //  "Total Paid",
                                    style: orderStyle,
                                  ),
                                  Text(
                                    "${pending.length}",
                                    style: orderStyle,
                                  )
                                ],
                              ),
                              divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Complete Orders",
                                    style: orderStyle,
                                  ),
                                  Text(
                                    "${complete.length}",
                                    style: orderStyle,
                                  )
                                ],
                              ),
                              divider()
                            ],
                          )
                        : const SizedBox(),
                    Table(
                      border:
                          TableBorder.all(color: Colors.black26, width: 1.5),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: const [
                        TableRow(children: [
                          Text(
                            'Sr #',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Customer Name',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Order Id',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Date',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Status',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ],
                    ),
                    !showList
                        ? repOrder.isNotEmpty
                            ? Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Table(
                                  border: TableBorder.all(
                                      color: Colors.black26, width: 1.5),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child: ListView.builder(
                                              itemCount: repOrder.length,
                                              shrinkWrap: true,
                                              primary: false,
                                              itemBuilder: (context, index) {
                                                return OrderReportsWidget(
                                                  order: repOrder[index],
                                                  index: index,
                                                );
                                              }))
                                    ])
                                  ],
                                ),
                              )
                            : const SizedBox()
                        : Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Table(
                              border: TableBorder.all(
                                  color: Colors.black26, width: 1.5),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(children: [
                                  TableCell(
                                      child: ListView.builder(
                                          itemCount: orders.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          itemBuilder: (context, index) {
                                            return OrderReportsWidget(
                                              order: orders[index],
                                              index: index,
                                            );
                                          }))
                                  // : TableCell(
                                  //     child: ListView.builder(
                                  //         itemCount: custList.length,
                                  //         shrinkWrap: true,
                                  //         primary: false,
                                  //         itemBuilder: (context, index) {
                                  //           return OrderReportsWidget(
                                  //             order: custList[index],
                                  //             index: index,
                                  //           );
                                  //         })),
                                ])
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight * 1.0,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: kSecondaryColor, width: 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DefaultButton(
              height: SizeConfig.screenHeight * 0.05,
              width: SizeConfig.screenWidth * 0.5,
              text: "Print Report",
              press: () async {
                if (showList ? orders.isEmpty : repOrder.isEmpty) {
                  showAwesomeAlert(
                    context: context,
                    msg: "No Payments for this customer",
                    onOkPress: () {},
                  );
                } else {
                  final data = await pdfInvoice.createInvoice(
                      context: context,
                      tPending: pending.length,
                      tComplete: complete.length,
                      order: showList == false ? repOrder : orders,
                      showCust: showList ? true : false);
                  int number = 0;
                  pdfInvoice.savePdfFile("invoice_$number", data);
                  number++;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class OrderReportsWidget extends StatelessWidget {
  const OrderReportsWidget({
    Key? key,
    required this.order,
    required this.index,
  }) : super(key: key);

  final SaleRapOrdersList order;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                // flex:2,
                child: Text(
              '${index + 1}',
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:3,
                child: Text(
              order.firstName!,
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SaleRepOrderReportDetailsScreen(
                              isInvoices: true,
                              orderId: order.orderId!,
                              name: "${order.firstName!}" " " + order.lastName!,
                              date: order.dateTime!,
                              orders: order,
                              isCustomer: false,
                            )));
              },
              child: Text(
                '${order.orderId}',
                style: tableStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                // flex:2,
                child: Text(
              getDate(order.dateTime),
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:3,
                child: Text(
              order.status!,
              style: TextStyle(
                  color: order.status == "Pending"
                      ? Colors.redAccent
                      : Colors.green),
              textAlign: TextAlign.center,
            )),
          ],
        ),
        divider(),
      ],
    );
  }
}
