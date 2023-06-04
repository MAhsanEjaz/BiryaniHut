// import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/salrrep_customer_order_aging_model.dart';
import 'package:shop_app/providers/salerep_customer_order_aging_provider.dart';
import 'package:shop_app/storages/login_storage.dart';
import '../../constants.dart';
import '../../services/sale_rep_customer_order_aging_service.dart';
import 'order_aging_report_pdf_screen.dart';

class SalesrepOrderAgingReportPage extends StatefulWidget {
  const SalesrepOrderAgingReportPage({Key? key}) : super(key: key);

  @override
  _OrderReportPageState createState() => _OrderReportPageState();
}

class _OrderReportPageState extends State<SalesrepOrderAgingReportPage> {
  // List<SaleRapOrdersList> orders = [];
  CustomerOrderAgingList? orderAging;
  customerOrderAgingHandler() async {
    CustomLoader.showLoader(context: context);
    await SaleRepCustomerOrderAgingService().getCustomerOrderAging(
        context: context, salerepId: LoginStorage().getUserId());

    orderAging =
        Provider.of<SaleRepCustomOrderAgingProvider>(context, listen: false)
            .orderAging!;

    setState(() {});
    CustomLoader.hideLoader(context);
    // ResellerCustomerProvider
  }

  ScrollController? controller;

  OrderAgingPdfInvoiceService pdfInvoiceService = OrderAgingPdfInvoiceService();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customerOrderAgingHandler();
    });
    super.initState();
  }

  String? agingDaysDDVal;

  bool showList = false;

  // OrderPdfInvoiceService pdfInvoice = OrderPdfInvoiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: iconTheme,
          backgroundColor: appColor,
          title: const Text(
            'Customers Orders Aging Reports',
            style: appbarTextStye,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    "Orders Aging Summary",
                    style: detailsStyle,
                  ),
                  divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Orders",
                          style: orderStyle,
                        ),
                        orderAging != null
                            ? Text(
                                orderAging!.saleRepTotalOrders!
                                    .toStringAsFixed(2),
                                style: orderStyle,
                              )
                            : const SizedBox.shrink()
                      ]),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: Colors.black26, width: 1.5),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                          'Delivery Awaited less than 5 days',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Delivery Awaited 5-10 days',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Delivery Awaited more than 10',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ],
                  ),
                  orderAging != null
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
                                // custList.isEmpty
                                // ?

                                TableCell(
                                    child: ListView.builder(
                                        itemCount:
                                            orderAging!.orderPayment!.length,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index) {
                                          return CustomerOrderAgingWidget(
                                            order: orderAging!
                                                .orderPayment![index],
                                            index: index,
                                          );
                                        }))
                              ])
                            ],
                          ),
                        )
                      : const Text("No record available")
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: reportButton(onTap: () async {
          final data = await pdfInvoiceService.createOrderAgingReport(
            context: context,
            payments: orderAging!.orderPayment!,
            totalOrders: orderAging!.saleRepTotalOrders.toString(),
          );
          int number = 0;
          pdfInvoiceService.savePdfFile("invoice_$number", data);
          number++;
        }));
  }
}

class CustomerOrderAgingWidget extends StatelessWidget {
  const CustomerOrderAgingWidget({
    Key? key,
    required this.order,
    required this.index,
  }) : super(key: key);

  final OrderAgingPayment order;
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
              order.customerName ?? "",
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:2,
                child: Text(
              '${order.first}',
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:2,
                child: Text(
              '${order.second}',
              // getDate(order.dateTime),
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:3,
                child: Text(
              '${order.last}',
              // order.status,
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
          ],
        ),
        divider(),
      ],
    );
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
