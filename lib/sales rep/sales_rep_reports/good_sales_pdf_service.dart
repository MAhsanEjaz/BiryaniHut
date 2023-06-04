import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_app/models/cost_of_good_sale_model.dart';
import '../../constants.dart';
import '../../models/salerep_payments_report_model.dart';
import '../../models/salesrep_all_customer_payment_model.dart';

class GoodSalePdfService {
  Future<Uint8List> createReport({
    required BuildContext context,
    List<GoodSaleModel>? saleCustomer,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
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
                    'Name',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Cost',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Revenue',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "Profit Margin",
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ]),
              ],
            ),
            pw.ListView.builder(
                itemCount: saleCustomer!.length,
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
                              saleCustomer[index].productName.toString(),

                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  saleCustomer[index].cost.toString(),
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              saleCustomer[index].revenue.toString(),

                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '11',
                              // style: tableStyle,
                              textAlign: pw.TextAlign.center,
                            )),
                      ],
                    ),
                    pw.Divider()
                  ]);
                })
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
