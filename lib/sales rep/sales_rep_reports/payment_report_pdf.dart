import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants.dart';
import '../../models/salerep_payments_report_model.dart';
import '../../models/salesrep_all_customer_payment_model.dart';

class PaymentReportPdfService {
  Future<Uint8List> createReport(
      {required BuildContext context,
      required String totalpayments,
      required String totalOrderPurchases,
      List<Payments>? order,
      List<SalesRepAllCustomersList>? allCustLists,
      bool showCust = false}) async {
    final pdf = pw.Document();
    var date = DateTime.now();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              showCust
                  ? "${order![0].customerName} Payments Report"
                  : "Customer Wise Payments Report",
              style: reportStyle,
            ),
            pw.Divider(),
            showCust
                ? pw.Column(children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Total Payments",
                          style: pdfOrderStyle,
                        ),
                        pw.Text(
                          totalpayments,
                        )
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Total Order Purchases",
                          style: pdfOrderStyle,
                        ),
                        pw.Text(
                          totalOrderPurchases,
                        )
                      ],
                    ),
                    pw.Divider(),
                  ])
                : pw.SizedBox(),
            pw.Table(
              border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0x000000), width: .5),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(children: [
                  pw.Text(
                    'Sr #',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Customer Name',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    showCust ? 'Payment Method' : 'Order Purchase',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    showCust ? 'Payment Method' : 'Amount Paid',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    showCust ? '   Date   ' : "Pendings",
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
              ],
            ),
            showCust
                ? pw.ListView.builder(
                    itemCount: order!.length,
                    itemBuilder: (context, index) {
                      return pw.Column(children: [
                        pw.Row(
                          // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  '${index + 1}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Text(
                                  order[index].customerName.toString(),

                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 5),
                                    child: pw.Text(
                                      getPaymentMethodName(
                                          '${order[index].paymentMethod}'),
                                      // style: tableStyle,
                                      textAlign: pw.TextAlign.center,
                                    ))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(
                                  order[index]
                                      .paymentAmount!
                                      .toStringAsFixed(2),

                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  getDate('${order[index].paymentDateTime}'),
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                          ],
                        ),
                        pw.Divider()
                      ]);
                    })
                : pw.ListView.builder(
                    itemCount: allCustLists!.length,
                    itemBuilder: (context, index) {
                      return pw.Column(children: [
                        pw.Row(
                          // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  '${index + 1}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Text(
                                  allCustLists[index].customerName.toString(),

                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 5),
                                    child: pw.Text(
                                      allCustLists[index]
                                          .totalOrderPurchase!
                                          .toStringAsFixed(2),
                                      // style: tableStyle,
                                      textAlign: pw.TextAlign.center,
                                    ))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(
                                  allCustLists[index]
                                      .totalAmountPaid!
                                      .toStringAsFixed(2),

                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  (allCustLists[index].totalOrderPurchase! -
                                          allCustLists[index].totalAmountPaid!)
                                      .toStringAsFixed(2),
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                )),
                          ],
                        ),
                        pw.Divider()
                      ]);
                    }),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Date",
                  style: pdfOrderStyle,
                ),
                pw.Text(
                  getDate(date.toString()) + " " + getTime(date.toString()),
                )
              ],
            ),
          ];
        }));
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFilex.open(filePath);
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
