import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../../constants.dart';
import '../../models/salrrep_customer_order_aging_model.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderAgingPdfInvoiceService {
  Future<Uint8List> createOrderAgingReport(
      {List<OrderAgingPayment>? payments,
      required String totalOrders,
      required BuildContext context}) async {
    final pdf = pw.Document();
    LoginStorage loginStorage = LoginStorage();
    var date = DateTime.now();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Sale Rep Name: ",
                  ),
                  pw.Text(
                      loginStorage.getUserFirstName() +
                          " " +
                          loginStorage.getUserLastName(),
                      style: const pw.TextStyle(fontSize: 14.0, height: 2.5)),
                ]),
            pw.SizedBox(height: 20.0),
            pw.Text(
              "Customer Wise Customer Orders Aging Report ",
              style: reportStyle,
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Total Orders",
                  style: pdfOrderStyle,
                ),
                pw.Text(
                  totalOrders,
                )
              ],
            ),
            pw.SizedBox(height: 20.0),
            pw.Table(
              border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0x000000), width: .6),
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
                    'Delivery Awaited less than 5 days',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Delivery Awaited 5-10 days',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Delivery Awaited more than 10',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
              ],
            ),
            pw.ListView.builder(
                itemCount: payments!.length,
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
                              // textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              payments[index].customerName ?? "",
                              // style: tableStyle,
                              // textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  '${payments[index].first}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              '${payments[index].second}',
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 10),
                                child: pw.Text(
                                  '${payments[index].last}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                      ],
                    ),
                    pw.Divider(),
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
}
