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
import '../../models/salesrep_orders_model.dart';

class OrderPdfInvoiceService {
  Future<Uint8List> createInvoice(
      {required BuildContext context,
      required int tPending,
      tComplete,
      required List<SaleRapOrdersList> order,
      bool showCust = false}) async {
    final pdf = pw.Document();
    var date = DateTime.now();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              showCust
                  ? order[0].firstName! + " " + order[0].lastName!
                  : "Customer Wise Orders Report ",
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
                  "${order.length}",
                )
              ],
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Pending Orders", //  "Total Paid",
                  style: pdfOrderStyle,
                ),
                pw.Text(
                  "$tPending",
                  // style: orderStyle,
                )
              ],
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Complete Orders", //  "Total Paid",
                  style: pdfOrderStyle,
                ),
                pw.Text(
                  "$tComplete",
                  // style: orderStyle,
                )
              ],
            ),
            pw.Divider(),
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
                    'Order Id',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Order Items',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    '   Date   ',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Status',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
              ],
            ),
            pw.ListView.builder(
                itemCount: order.length,
                itemBuilder: (context, index) {
                  return pw.Column(children: [
                    pw.Row(
                      // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '${index + 1}',
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              order[index].firstName! +
                                  " " +
                                  order[index].lastName!,
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  '${order[index].orderId}',
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '${order[index].orderProducts!.length}',
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 10),
                                child: pw.Text(
                                  getDate(order[index].dateTime),
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              order[index].status!,
                              style: pw.TextStyle(
                                  color: order[index].status == "Pending"
                                      ? const PdfColor.fromInt(0xffff8a80)
                                      : const PdfColor.fromInt(0xff008542)),
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
