import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/cost_of_good_sale_model.dart';
import 'package:shop_app/models/top_five_product_model.dart';

class TopFivePdfService {
  Future<Uint8List> createReport({
    required BuildContext context,
    List<TopFiveProductsModel>? saleCustomer,
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
                    'Product Name',
                    style: pdfTitleStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "Orders",
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
                                  saleCustomer[index].totalOrders.toString(),
                                  // style: tableStyle,
                                  textAlign: pw.TextAlign.center,
                                ))),
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
