// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
// import 'package:pdf/widgets.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/storages/login_storage.dart';

// import '../../../../models/salesrep_orders_model.dart';

// class CustomRow {
//   final String name;
//   final String qnty;
//   final String price;

//   CustomRow(
//     this.name,
//     this.qnty,
//     this.price,
//   );
// }

// class PdfOrdersInvoiceService {
//   LoginStorage loginStorage = LoginStorage();
//   Future<Uint8List> createInvoice(
//       {required SaleRapOrdersList order,
//       required String repName,
//       required String customerName,
//       // PdfViewModel? view,
//       required BuildContext ctx}) async {
//     final pdf = pw.Document();

//     final font = await rootBundle.load("assets/fonts/muli/Muli.ttf");
//     final ttf = Font.ttf(font);

//     final List<CustomRow> elements = [
//       // for (int i = 0; i < view!.order!.length; i++)
//       // for (int i = 0; i < 3; i++)
//       //   CustomRow(
//       //     "Influence Antiseptic",
//       //     getValue(1000),
//       //     getValue(2535561),
//       //   )
//       for (int i = 0; i < order.orderProducts!.length; i++)
//         CustomRow(
//           // Methods().getFormatedDate(ledgerDetails[i].date!),
//           order.orderProducts![i].productName ?? "",
//           "  "
//           "${order.orderProducts![i].quantity.toString()}",
//           getValue(order.orderProducts![i].price!.toDouble()),
//           // "${item[i].productDescription??""}",
//         )
//     ];

//     final influnanceLogo =
//         (await rootBundle.load("assets/images/Influance-logo.png"))
//             .buffer
//             .asUint8List();

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return <pw.Widget>[
//             // pw.Text("From :",
//             //     style: pw.TextStyle(
//             //         color: PdfColor.fromInt(0x000000),
//             //         fontSize: 18.0,
//             //         fontWeight: pw.FontWeight.bold)),

//             pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.start,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                             // "Dealer Name :" + "  " + usermodels!.name!,
//                             " Sales Rep Name :"
//                                     "  " +
//                                 repName,
//                             style: pw.TextStyle(font: ttf)),

//                         pw.Text(
//                             // "Dealer Name :" + "  " + usermodels!.name!,
//                             " Customer Name :"
//                                     "  " +
//                                 customerName,
//                             style: pw.TextStyle(font: ttf)
//                             // style: dealStyle
//                             ),

//                         pw.Text(
//                             // "Dealer Name :" + "  " + usermodels!.name!,
//                             "Order Id :"
//                                     "  " +
//                                 order.orderId.toString(),
//                             style: pw.TextStyle(font: ttf)
//                             // style: dealStyle
//                             ),
//                         // pw.RichText(
//                         //     text: pw.TextSpan(
//                         //         text: "Dealer Name:" + " ",
//                         //         style: dealStyle,
//                         //         children: [
//                         //       pw.TextSpan(
//                         //           text: "Asad Ali",
//                         //           style: pw.TextStyle(
//                         //               color: PdfColor.fromInt(0xff222222),
//                         //               fontSize: 12.0))
//                         //     ])
//                         //     ),
//                         pw.RichText(
//                             text: pw.TextSpan(
//                                 text: "Order Time:" " ",
//                                 style: pw.TextStyle(font: ttf),
//                                 // style: dealStyle,
//                                 children: [
//                               pw.TextSpan(
//                                   text: getDate(order.dateTime) +
//                                       " " +
//                                       getTime(order.dateTime),
//                                   style: pw.TextStyle(
//                                       font: ttf,
//                                       color: PdfColor.fromInt(0xff222222),
//                                       fontSize: 12.0))
//                             ])),

//                         // pw.Text(
//                         //   // "Dealer Name :" + "  " + usermodels!.name!,
//                         //     " Date Of Issue :" + "  " + "${"12/05/2021"}",
//                         //     style: pw.TextStyle(
//                         //       fontSize: 14,
//                         //       height: 1.8,
//                         //       fontWeight: pw.FontWeight.bold,
//                         //       color: PdfColor.fromInt(0x000000),
//                         //     )),
//                       ]),
//                   pw.Image(pw.MemoryImage(influnanceLogo), width: 150.0),
//                 ]),
//             // pw.Container(
//             //     padding: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             //     width: double.infinity,
//             //     height: 50,
//             //     color: PdfColor.fromInt(0xF5F5F5),
//             //     child: pw.Text(
//             //         // "Dealer Name :" + "  " + usermodels!.name!,
//             //         " Name :" + "  " + "${loginStorage.getUserFirstName()}",
//             //         style: pw.TextStyle(
//             //           fontSize: 12,
//             //           fontWeight: pw.FontWeight.bold,
//             //           color: PdfColor.fromInt(0x000000),
//             //         ))
//             // ),
//             pw.Container(
//                 padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
//                 width: double.infinity,
//                 child: pw.Column(
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text("Influance Invoice",
//                           style: pw.TextStyle(
//                             fontSize: 18,
//                             font: ttf,
//                             fontWeight: pw.FontWeight.bold,
//                             color: const PdfColor.fromInt(0x000000),
//                           )),
//                       if (order.orderPayment!.isNotEmpty) pw.Divider(),
//                       if (order.orderPayment!.isNotEmpty)
//                         pw.ListView.builder(
//                           itemCount: order.orderPayment!.length,

//                           // physics: NeverScrollableScrollPhysics(),
//                           // shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return pw.Column(
//                               children: [
//                                 if (index == 0)
//                                   pw.Text(
//                                     "Payment Details",
//                                     style: pw.TextStyle(
//                                         fontWeight: pw.FontWeight.bold,
//                                         font: ttf,
//                                         fontSize: 16),
//                                   ),
//                                 pw.Row(
//                                   mainAxisAlignment:
//                                       pw.MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment:
//                                       pw.CrossAxisAlignment.start,
//                                   children: [
//                                     pw.Text(
//                                       getPaymentMethodName(
//                                         order.orderPayment![index]
//                                                 .paymentMethod ??
//                                             "",
//                                       ),
//                                       style: pw.TextStyle(
//                                           fontSize: 16.0,
//                                           font: ttf,
//                                           fontWeight: pw.FontWeight.normal,
//                                           height: 2.2),
//                                     ),
//                                     pw.Text(
//                                       "${order.orderPayment![index].paymentAmount}",
//                                       style: pw.TextStyle(
//                                           fontSize: 16.0,
//                                           font: ttf,
//                                           fontWeight: pw.FontWeight.normal,
//                                           height: 2.2),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                     ])),

//             pw.Container(
//                 width: double.infinity,
//                 padding: const pw.EdgeInsets.symmetric(vertical: 10),
//                 decoration: const pw.BoxDecoration(
//                   color: PdfColor.fromInt(0xFFFFFF),
//                 ),
//                 child: pw.Column(
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Expanded(
//                                 flex: 1,
//                                 child: pw.Text("Name",
//                                     style: pw.TextStyle(font: ttf))),

//                             // pw.Align(
//                             //                     alignment: pw.Alignment.centerRight,
//                             // )

//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Text("Quantity",
//                                   style: pw.TextStyle(font: ttf),
//                                   textAlign: pw.TextAlign.left),
//                             ),
//                             pw.Align(
//                               alignment: pw.Alignment.centerRight,
//                               child: pw.Expanded(
//                                   flex: 1,
//                                   child: pw.Text("Price",
//                                       style: pw.TextStyle(font: ttf))),
//                             ),

//                             // pw.Text("Name",
//                             //     style: pw.TextStyle(
//                             //       fontSize: 14,
//                             //       fontWeight: pw.FontWeight.bold,
//                             //       color: PdfColor.fromInt(0x000000),
//                             //     )),
//                             // pw.Text("Quantity",
//                             //     style: pw.TextStyle(
//                             //       fontSize: 14,
//                             //       fontWeight: pw.FontWeight.bold,
//                             //       color: PdfColor.fromInt(0x000000),
//                             //     )),
//                             // pw.Text("Price",
//                             //     style: pw.TextStyle(
//                             //       fontSize: 14,
//                             //       fontWeight: pw.FontWeight.bold,
//                             //       color: PdfColor.fromInt(0x000000),
//                             //     )),
//                           ]),
//                       pw.Container(
//                         width: double.infinity,
//                         height: 1,
//                         color: const PdfColor.fromInt(0xF5F5F5),
//                       ),
//                     ])),

//             itemColumn(elements, ttf),
//             pw.Padding(
//               padding: const pw.EdgeInsets.symmetric(
//                   horizontal: 15.0, vertical: 8.0),
//               child: pw.Align(
//                   alignment: pw.Alignment.topRight,
//                   child: pw.Container(
//                     width: MediaQuery.of(ctx).size.width / 1.7,
//                     child: pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.start,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: []),
//                           pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text("Previous Balance :" " ",
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.bold,
//                                       height: 1.6,
//                                       color: const PdfColor.fromInt(0xff000000),
//                                     )),
//                                 pw.Text(
//                                     // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
//                                     //
//                                     order.previousBalance!.toStringAsFixed(2),
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.normal,
//                                       color: const PdfColor.fromInt(0x000000),
//                                     )),
//                               ]),
//                           pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text("Order Amount :" " ",
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.bold,
//                                       height: 1.6,
//                                       color: const PdfColor.fromInt(0xff000000),
//                                     )),
//                                 pw.Text(
//                                     // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
//                                     //
//                                     order.totalPrice!.toStringAsFixed(2),
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.normal,
//                                       color: const PdfColor.fromInt(0x000000),
//                                     )),
//                               ]),
//                           pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text("Total Payments :" " ",
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.bold,
//                                       height: 1.6,
//                                       color: const PdfColor.fromInt(0xff000000),
//                                     )),
//                                 pw.Text(
//                                     // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
//                                     //
//                                     order.orderPaidAmount!.toStringAsFixed(2),
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.normal,
//                                       color: const PdfColor.fromInt(0x000000),
//                                     )),
//                               ]),
//                           pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text("Remaining Balance :" " ",
//                                     style: pw.TextStyle(
//                                       fontSize: 12,
//                                       font: ttf,
//                                       fontWeight: pw.FontWeight.bold,
//                                       height: 1.6,
//                                       color: const PdfColor.fromInt(0xff000000),
//                                     )),
//                                 pw.Text(
//                                     // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
//                                     //
//                                     order.orderPendingPayment!
//                                         .toStringAsFixed(2),
//                                     style: pw.TextStyle(
//                                       font: ttf,
//                                       fontSize: 12,
//                                       fontWeight: pw.FontWeight.normal,
//                                       color: const PdfColor.fromInt(0x000000),
//                                     )),
//                               ]),
//                         ]),
//                   )),
//             ),

//             pw.SizedBox(height: 25),
//             pw.Text(
//                 "Thank you for being a valued customer. We hope to serve you again in the near future",
//                 style: pw.TextStyle(font: ttf)),
//             pw.SizedBox(height: 25),
//             pw.Text("Kind regards,", style: pw.TextStyle(font: ttf)),
//             pw.SizedBox(height: 30),
//             pw.Align(
//               alignment: pw.Alignment.topRight,
//               child: pw.Row(children: [
//                 pw.Text("Invoice Created at :  ",
//                     style: pw.TextStyle(font: ttf)),
//                 pw.Text(getDate(DateTime.now().toString()),
//                     style: pw.TextStyle(font: ttf)),
//                 pw.SizedBox(width: 10),
//                 pw.Text(getTime(DateTime.now().toString()),
//                     style: pw.TextStyle(font: ttf)),
//               ]),
//             ),
//           ];
//         },
//       ),
//     );
//     return pdf.save();
//   }

//   itemColumn(List<CustomRow> elements, var ttf) {
//     return pw.Column(
//       children: [
//         for (var element in elements)
//           pw.Column(
//               // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Expanded(
//                         flex: 1,
//                         child: pw.Text(
//                           element.name,
//                           style: pw.TextStyle(font: ttf),
//                         )),

//                     // pw.Align(
//                     //                     alignment: pw.Alignment.centerRight,
//                     // )

//                     pw.Expanded(
//                       flex: 1,
//                       child: pw.Text(
//                         element.qnty,
//                       ),
//                     ),
//                     pw.Align(
//                       alignment: pw.Alignment.centerRight,
//                       child: pw.Expanded(
//                           flex: 1,
//                           child: pw.Text(
//                               (double.parse(element.price) *
//                                       double.parse(element.qnty))
//                                   .toStringAsFixed(2),
//                               style: pw.TextStyle(font: ttf))),
//                     ),
//                   ],
//                 ),
//                 // pw.Text(element.discription.isEmpty?"null":element.discription,
//                 //     style: pw.TextStyle(
//                 //       fontSize: 8,
//                 //       color: PdfColor.fromInt(0xFF1cbcb3),
//                 //     )),
//                 pw.Container(
//                   margin: const pw.EdgeInsets.symmetric(vertical: 5),
//                   width: double.infinity,
//                   height: 1,
//                   color: const PdfColor.fromInt(0x999999),
//                 ),
//               ]),
//       ],
//     );
//   }

//   String getPaymentMethodName(String value) {
//     String paymentName = "";

//     if (value == "1") {
//       paymentName = "Cash";
//     } else if (value == "2") {
//       paymentName = "Stripe";
//     } else if (value == "3") {
//       paymentName = "Paypal";
//     } else if (value == "4") {
//       paymentName = "Google Pay";
//     } else if (value == "5") {
//       paymentName = "Apple Pay";
//     } else if (value == "6") {
//       paymentName = "Sumup";
//     } else if (value == "7") {
//       paymentName = "Cheque";
//     } else if (value == "8") {
//       paymentName = "Cash App";
//     }

//     return paymentName;
//   }

//   Future<void> savePdfFile(String fileName, Uint8List byteList) async {
//     final output = await getTemporaryDirectory();
//     var filePath = "${output.path}/$fileName.pdf";
//     final file = File(filePath);
//     await file.writeAsBytes(byteList);
//     await OpenFile.open(filePath);
//   }

//   String getValue(num value) {
//     if (value == 0.0) {
//       return "0.0";
//     } else {
//       return value.toStringAsFixed(2);
//     }
//   }
// }
