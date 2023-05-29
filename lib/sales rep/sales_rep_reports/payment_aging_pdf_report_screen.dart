import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../../constants.dart';
import '../../models/sales_rep_customer_payment_aging_model.dart';
import 'package:pdf/widgets.dart' as pw;

class PaymentAgingPdfReport {
  Future<Uint8List> createInvoice(
      {required BuildContext context,
      required List<CustomerPaymentAgingList> agingList}) async {
    final pdf = pw.Document();
    var date = DateTime.now();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (
          pw.Context context,
        ) {
          return [
            pw.Text(
              "Customer Wise Customer Payments Aging Report ",
              style: reportStyle,
            ),
            pw.Divider(),
            pw.SizedBox(height: 20.0),
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
                    'OverDue less than 5 days',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'OverDue 5-10 days',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'more than 10 days',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
              ],
            ),
            pw.SizedBox(height: 10.0),
            pw.ListView.builder(
                itemCount: agingList.length,
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
                              agingList[index].customerName ?? "",
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  '${agingList[index].first!.toStringAsFixed(2)}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              '${agingList[index].second!.toStringAsFixed(2)}',
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 10),
                                child: pw.Text(
                                  '${agingList[index].third! < 0 ? 0 : agingList[index].third!.toStringAsFixed(2)}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        // pw.Expanded(
                        //     flex: 3,
                        //     child: pw.Padding(
                        //         padding: const pw.EdgeInsets.only(left: 10),
                        //         child: pw.Text(
                        //           '${agingList[index].last!.toStringAsFixed(2)}',
                        //           // style: tableStyle,
                        //           textAlign: pw.TextAlign.center,
                        //         ))),
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
                  "${getDate(date.toString())}" +
                      " " +
                      "${getTime(date.toString())}",
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
}
