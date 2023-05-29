import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/salerep_payments_report_provider.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/payment_report_pdf.dart';
import 'package:shop_app/services/salesrep_all_customers_payment_service.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../models/resseller_customers_model.dart';
import '../../models/salerep_payments_report_model.dart';
import '../../models/salesrep_all_customer_payment_model.dart';
import '../../providers/reseller_customer_provider.dart';
import '../../providers/salesrep_all_customer_payment_provider.dart';
import '../../services/reseller_customers_service.dart';
import '../../services/salerep_payments_service.dart';

class SalesrepPaymentsReportPage extends StatefulWidget {
  const SalesrepPaymentsReportPage({Key? key}) : super(key: key);

  @override
  _OrderReportPageState createState() => _OrderReportPageState();
}

class _OrderReportPageState extends State<SalesrepPaymentsReportPage> {
  SaleRepPaymentsReportModel? payReport;
  List<SalesRepAllCustomersList>? allCustLists = [];
  bool showSingleCustomerData = false;
  //////initial Handler
  salerepAllCustPayHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesRepAllCustomersPaymentsService().getCustomersPaymentsList(
        context: context, saleRepId: LoginStorage().getUserId(), days: 0);
    allCustLists = Provider.of<SalesrepAllCustomersPaymentsProvider>(context,
            listen: false)
        .custList!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  ///On Change
  paymentsReportHandler(int customerId) async {
    CustomLoader.showLoader(context: context);
    await SaleRepPaymentsReportService()
        .getPayments(context: context, customerId: customerId, days: 0);
    payReport =
        Provider.of<SaleRepPaymentsReportsProvider>(context, listen: false)
            .report;

    setState(() {});
    CustomLoader.hideLoader(context);
  }

  List<SalesrepCustomerData> resellerList = [];
  getResellerCustomerListHandler() async {
    CustomLoader.showLoader(context: context);
    await ResellerCustomerService()
        .getCustomerList(context: context, isReport: true);
    resellerList =
        Provider.of<ResellerCustomerProvider>(context, listen: false).custList!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // paymentsReportHandler(1072);
      salerepAllCustPayHandler();
      getResellerCustomerListHandler();
    });
    super.initState();
  }

  int? selectedCustomerId;

  PaymentReportPdfService pdfService = PaymentReportPdfService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          'Customer Wise Payment Reports',
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      height: 45.0,
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: selectedCustomerId,
                        hint: const Text("Select Customer"),
                        underline: const SizedBox(),
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        items: resellerList.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item.firstName! + " " + item.lastName!,
                            ),
                            value: item.id,
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value == 1084) {
                            selectedCustomerId = value;
                            showSingleCustomerData = false;
                            salerepAllCustPayHandler();
                          } else {
                            selectedCustomerId = value;
                            showSingleCustomerData = true;
                            paymentsReportHandler(selectedCustomerId!);

                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  const Text(
                    "Payment Summary",
                    style: detailsStyle,
                  ),
                  divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showSingleCustomerData == true
                          ? payReport != null
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Total Order Purchases",
                                          style: orderStyle,
                                        ),
                                        Text(
                                          payReport!.data!.totalOrderPurchase!
                                              .toStringAsFixed(2),
                                          style: orderStyle,
                                        )
                                      ],
                                    ),
                                    divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Total Amount Paid",
                                          style: orderStyle,
                                        ),
                                        Text(
                                          payReport!.data!.totalAmountPaid!
                                              .toStringAsFixed(2),
                                          style: orderStyle,
                                        )
                                      ],
                                    ),
                                    divider(),
                                  ],
                                )
                              : const SizedBox()
                          : const SizedBox(),
                      Table(
                        border:
                            TableBorder.all(color: Colors.black26, width: 1.5),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            const Text(
                              'Sr #',
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Customer Name',
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              showSingleCustomerData
                                  ? 'Payment Method'
                                  : "Order Purchase",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              showSingleCustomerData ? 'Amount' : "Amount Paid",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              showSingleCustomerData ? 'Date' : "Pendings",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ]),
                        ],
                      ),
                      showSingleCustomerData == true
                          ? payReport != null &&
                                  payReport!.data!.payments!.isNotEmpty
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
                                                itemCount: payReport!
                                                    .data!.payments!.length,
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 4.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              '${index + 1}',
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:3,
                                                                child: Text(
                                                              payReport!
                                                                  .data!
                                                                  .payments![
                                                                      index]
                                                                  .customerName
                                                                  .toString(),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              getPaymentMethodName(
                                                                  '${payReport!.data!.payments![index].paymentMethod}'),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              payReport!
                                                                  .data!
                                                                  .payments![
                                                                      index]
                                                                  .paymentAmount!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              getDate(payReport!
                                                                  .data!
                                                                  .payments![
                                                                      index]
                                                                  .paymentDateTime),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                          ],
                                                        ),
                                                        index ==
                                                                payReport!
                                                                        .data!
                                                                        .payments!
                                                                        .length -
                                                                    1
                                                            ? const SizedBox()
                                                            : divider(),
                                                      ],
                                                    ),
                                                  );
                                                })),
                                      ])
                                    ],
                                  ),
                                )
                              : const SizedBox()
                          : allCustLists!.isNotEmpty && allCustLists != null
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
                                                itemCount: allCustLists!.length,
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 4.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              '${index + 1}',
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:3,
                                                                child: Text(
                                                              allCustLists![
                                                                          index]
                                                                      .customerName ??
                                                                  "",
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              allCustLists![
                                                                      index]
                                                                  .totalOrderPurchase!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              allCustLists![
                                                                      index]
                                                                  .totalAmountPaid!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            Expanded(
                                                                // flex:2,
                                                                child: Text(
                                                              (allCustLists![index]
                                                                          .totalOrderPurchase! -
                                                                      allCustLists![
                                                                              index]
                                                                          .totalAmountPaid!)
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: tableStyle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                          ],
                                                        ),
                                                        index ==
                                                                allCustLists!
                                                                        .length -
                                                                    1
                                                            ? const SizedBox()
                                                            : divider(),
                                                      ],
                                                    ),
                                                  );
                                                })),
                                      ])
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                    ],
                  )
                ],
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
                if (showSingleCustomerData
                    ? payReport!.data!.payments!.isEmpty
                    : allCustLists!.isEmpty) {
                  showAwesomeAlert(
                    context: context,
                    msg: "No Payments for this customer",
                    onOkPress: () {},
                  );
                } else {
                  final data = await pdfService.createReport(
                      context: context,
                      order: showSingleCustomerData
                          ? payReport!.data!.payments!
                          : [],
                      totalOrderPurchases: showSingleCustomerData
                          ? "${payReport!.data!.totalOrderPurchase ?? ""}"
                          : 0.toString(),
                      totalpayments: showSingleCustomerData
                          ? "${payReport!.data!.totalAmountPaid ?? ""}"
                          : 0.toString(),
                      allCustLists:
                          showSingleCustomerData == false ? allCustLists : [],
                      showCust: showSingleCustomerData ? true : false);
                  int number = 0;

                  pdfService.savePdfFile("invoice_$number", data);
                  number++;
                }
              },
            )
          ],
        ),
      ),
    );
  }

  String getPaymentMethodName(String value) {
    String paymentName = "";

    if (value == "1") {
      paymentName = "Cash";
    } else if (value == "2") {
      paymentName = "Stripe";
    } else if (value == "3") {
      paymentName = "Paypal";
    } else if (value == "4") {
      paymentName = "Google Pay";
    } else if (value == "5") {
      paymentName = "Apple Pay";
    } else if (value == "6") {
      paymentName = "Sumup";
    } else if (value == "7") {
      paymentName = "Cheque";
    } else if (value == "8") {
      paymentName = "Cash App";
    }

    return paymentName;
  }
}

class PieData {
  final String category;
  final int value;
  final String title;
  final Color color;

  PieData(this.category, this.value, this.title, this.color);
}

// return Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
//
// ReportWidget(pendingOrders: '${pending.length}',
// compOrders: "${complete.length}",
// totalOrders: "${order.repOrder!.length}",
// ),
// SfCircularChart(
// series: <CircularSeries>[
// PieSeries<PieData, String>(
// dataSource: _data,
// xValueMapper: (PieData data, _) => data.category,
// yValueMapper: (PieData data, _) => data.value,
// pointColorMapper: (PieData data, _) => data.color,
// dataLabelSettings: DataLabelSettings(isVisible: true),
// enableTooltip: true,
// ),
//
// ],
// tooltipBehavior: TooltipBehavior(
// enable: true,
// format: 'point.x : point.y% \n${'Title'}: point.data.title'
// ),
// ),
// ],
// );
// final List<PieData> _data = [
//   // PieData('A', order.repOrder!.length, 'Total Orders', Colors.red),
//   PieData('B', pending.length, 'Pending', Colors.redAccent),
//   PieData('C', complete.length, 'Complete', Colors.green),
// ];
