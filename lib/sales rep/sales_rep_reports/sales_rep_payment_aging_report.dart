import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/payment_aging_pdf_report_screen.dart';

import '../../models/sales_rep_customer_payment_aging_model.dart';
import '../../providers/salesrep_customer_payment_aging_provider.dart';
import '../../services/sales_rep_customer_payment_aging_service.dart';

class SalesRepPaymentAgingReport extends StatefulWidget {
  const SalesRepPaymentAgingReport({Key? key}) : super(key: key);

  @override
  State<SalesRepPaymentAgingReport> createState() =>
      _SalesRepPaymentAgingReportState();
}

class _SalesRepPaymentAgingReportState
    extends State<SalesRepPaymentAgingReport> {
  List<CustomerPaymentAgingList> agingList = [];

  paymentAgingHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesRepCustomerPaymentAgingService()
        .getPayments(context: context, saleRepId: 1);
    agingList = Provider.of<SalesRepCustomerPaymentAgingProvider>(context,
            listen: false)
        .paymentsAging!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentAgingHandler();
    });
    super.initState();
  }

  PaymentAgingPdfReport pdfReport = PaymentAgingPdfReport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          "Customer Payment Aging Report",
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payments Aging Summary",
                  style: detailsStyle,
                ),
                divider(),
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
                        'Overdue less than 5 days (\$)',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Overdue 5-10 days (\$)',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'More than 10 days (\$)',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      // Text(
                      //   'More than 15',
                      //   style: titleStyle,
                      //   textAlign: TextAlign.center,
                      // ),
                    ]),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Table(
                    border: TableBorder.all(color: Colors.black26, width: 1.5),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        agingList.isNotEmpty && agingList != null
                            ? ListView.builder(
                                itemCount: agingList.length,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (build, index) {
                                  return CustomerPaymentsAgingWidget(
                                    payments: agingList[index],
                                    index: index,
                                    listLength: agingList.length,
                                  );
                                })
                            : const SizedBox()
                      ])
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: reportButton(onTap: () async {
        final data = await pdfReport.createInvoice(
            context: context, agingList: agingList);
        int number = 0;
        pdfReport.savePdfFile("invoice_$number", data);
        number++;
      }),
    );
  }
}

class CustomerPaymentsAgingWidget extends StatelessWidget {
  const CustomerPaymentsAgingWidget({
    Key? key,
    required this.payments,
    required this.index,
    required this.listLength,
  }) : super(key: key);

  final CustomerPaymentAgingList payments;
  final int index;
  final int listLength;

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
              "${payments.customerName}",
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:2,
                child: Text(
              (payments.first! < 0 ? 0 : payments.first!).toStringAsFixed(2),
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:2,
                child: Text(
              (payments.second! < 0 ? 0 : payments.second!).toStringAsFixed(2),
              // getDate(order.dateTime),
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
            Expanded(
                // flex:3,
                child: Text(
              (payments.third! < 0 ? 0 : payments.third!).toStringAsFixed(2),
              // order.status,
              style: tableStyle,
              textAlign: TextAlign.center,
            )),
          ],
        ),
        index == listLength - 1
            ? const SizedBox(
                height: 5.0,
              )
            : divider(),
      ],
    );
  }
}
