import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../constants.dart';

class CustomRow {
  final String name;
  final String qnty;
  final String price;

  CustomRow(
    this.name,
    this.qnty,
    this.price,
  );
}

class PdfInvoiceService {
  LoginStorage loginStorage = LoginStorage();
  String orderStatus = '';

  Future<Uint8List> createInvoice(
      {required CartModel cartModel,
      required String repName,
      required String customerName,
      required bool isOrderCompleted,
      required String repCompanyName,
      String? discountValue,
      bool? isDiscountInPercent,
      // PdfViewModel? view,
      required BuildContext ctx}) async {
    final pdf = pw.Document();
    if (isOrderCompleted) {
      orderStatus = "Completed";
    } else {
      orderStatus = "Pending";
    }

    final List<CustomRow> elements = [
      // for (int i = 0; i < view!.order!.length; i++)
      // for (int i = 0; i < 3; i++)
      //   CustomRow(
      //     "Influence Antiseptic",
      //     getValue(1000),
      //     getValue(2535561),
      //   )
      for (int i = 0; i < cartModel.orderProducts.length; i++)
        CustomRow(
          // Methods().getFormatedDate(ledgerDetails[i].date!),
          cartModel.orderProducts[i].productName,
          "  "
          "${cartModel.orderProducts[i].quantity.toString()}",
          getValue(cartModel.orderProducts[i].price.toDouble()),
          // "${item[i].productDescription??""}",
        )
    ];

    final influnanceLogo =
        (await rootBundle.load("assets/images/Influance-logo.png"))
            .buffer
            .asUint8List();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            // pw.Text("From :",
            //     style: pw.TextStyle(
            //         color: PdfColor.fromInt(0x000000),
            //         fontSize: 18.0,
            //         fontWeight: pw.FontWeight.bold)),

            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            // "Dealer Name :" + "  " + usermodels!.name!,
                            "Sales Rep Name:"
                                    "  " +
                                repName
                            // style: dealStyle
                            ),
                        // pw.Text(
                        //     // "Dealer Name :" + "  " + usermodels!.name!,
                        //     "Sales Rep Company:"
                        //             "  " +
                        //         repCompanyName
                        //     // style: dealStyle
                        //     ),
                        pw.Text(
                          // "Dealer Name :" + "  " + usermodels!.name!,
                          "Customer Name :"
                                  "  " +
                              customerName,
                          // style: dealStyle
                        ),

                        pw.Text(
                          // "Dealer Name :" + "  " + usermodels!.name!,
                          "Order Status :"
                                  "  " +
                              orderStatus,
                          // style: dealStyle
                        ),
                        // pw.RichText(
                        //     text: pw.TextSpan(
                        //         text: "Dealer Name:" + " ",
                        //         style: dealStyle,
                        //         children: [
                        //       pw.TextSpan(
                        //           text: "Asad Ali",
                        //           style: pw.TextStyle(
                        //               color: PdfColor.fromInt(0xff222222),
                        //               fontSize: 12.0))
                        //     ])
                        //     ),
                        // pw.RichText( //! for now date time is not showing becasue order is not placed
                        //     text: pw.TextSpan(
                        //         text: "Date:" + " ",
                        //         style: dealStyle,
                        //         children: [
                        //       pw.TextSpan(
                        //           text: getDate(cartModel.dateTime) +
                        //               " " +
                        //               getTime(cartModel.dateTime),
                        //           style: pw.TextStyle(
                        //               color: PdfColor.fromInt(0xff222222),
                        //               fontSize: 12.0))
                        //     ])),

                        // pw.Text(
                        //   // "Dealer Name :" + "  " + usermodels!.name!,
                        //     " Date Of Issue :" + "  " + "${"12/05/2021"}",
                        //     style: pw.TextStyle(
                        //       fontSize: 14,
                        //       height: 1.8,
                        //       fontWeight: pw.FontWeight.bold,
                        //       color: PdfColor.fromInt(0x000000),
                        //     )),
                      ]),
                  pw.Image(pw.MemoryImage(influnanceLogo), width: 150.0),
                ]),
            // pw.Container(
            //     padding: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            //     width: double.infinity,
            //     height: 50,
            //     color: PdfColor.fromInt(0xF5F5F5),
            //     child: pw.Text(
            //         // "Dealer Name :" + "  " + usermodels!.name!,
            //         " Name :" + "  " + "${loginStorage.getUserFirstName()}",
            //         style: pw.TextStyle(
            //           fontSize: 12,
            //           fontWeight: pw.FontWeight.bold,
            //           color: PdfColor.fromInt(0x000000),
            //         ))
            // ),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
                width: double.infinity,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Influance Invoice",
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: const PdfColor.fromInt(0x000000),
                          )),
                      if (cartModel.orderPayment.isNotEmpty) pw.Divider(),
                      if (cartModel.orderPayment.isNotEmpty)
                        pw.ListView.builder(
                          itemCount: cartModel.orderPayment.length,

                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return pw.Column(
                              children: [
                                if (index == 0)
                                  pw.Text(
                                    "Payment Details",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                pw.Row(
                                  // mainAxisAlignment:
                                  //     pw.MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Expanded(
                                      flex: 1,
                                      child: pw.Text(
                                        getPaymentMethodName(cartModel
                                            .orderPayment[index].paymentMethod),
                                        style: pw.TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: pw.FontWeight.normal,
                                            height: 2.2),
                                      ),
                                    ),
                                    if (cartModel
                                            .orderPayment[index].chequeNo !=
                                        null)
                                      pw.Expanded(
                                        flex: 1,
                                        child: pw.Text(
                                          "${cartModel.orderPayment[index].chequeNo}",
                                          style: pw.TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: pw.FontWeight.normal,
                                              height: 2.2),
                                        ),
                                      ),
                                    pw.Expanded(
                                        flex: 1,
                                        child: pw.Text(
                                          "${cartModel.orderPayment[index].paymentAmount}",
                                          style: pw.TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: pw.FontWeight.normal,
                                              height: 2.2),
                                        )),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                    ])),

            pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.symmetric(vertical: 10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFFFFF),
                ),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  "Name",
                                )),

                            // pw.Align(
                            //                     alignment: pw.Alignment.centerRight,
                            // )

                            pw.Expanded(
                              flex: 1,
                              child: pw.Text("Quantity",
                                  textAlign: pw.TextAlign.left),
                            ),
                            pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child:
                                  pw.Expanded(flex: 1, child: pw.Text("Price")),
                            ),

                            // pw.Text("Name",
                            //     style: pw.TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: pw.FontWeight.bold,
                            //       color: PdfColor.fromInt(0x000000),
                            //     )),
                            // pw.Text("Quantity",
                            //     style: pw.TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: pw.FontWeight.bold,
                            //       color: PdfColor.fromInt(0x000000),
                            //     )),
                            // pw.Text("Price",
                            //     style: pw.TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: pw.FontWeight.bold,
                            //       color: PdfColor.fromInt(0x000000),
                            //     )),
                          ]),
                      pw.Container(
                        width: double.infinity,
                        height: 1,
                        color: PdfColor.fromInt(0xF5F5F5),
                      ),
                    ])),

            itemColumn(elements),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Container(
                    width: MediaQuery.of(ctx).size.width / 1.7,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Previous Balance :" " ",
                                    style: pdfHeaderStyle),
                                pw.Text(
                                    // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
                                    //
                                    cartModel.previousBalance
                                        .toStringAsFixed(2),
                                    style: pdfStyle),
                              ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Today's Order Amount :" " ",
                                    style: pdfHeaderStyle),
                                pw.Text(
                                    // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
                                    //
                                    cartModel.totalPrice.toStringAsFixed(2),
                                    style: pdfStyle),
                              ]),
                          if (isDiscountInPercent != null &&
                              discountValue != null)
                            pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Discount on Order :" " ",
                                      style: pdfHeaderStyle),
                                  pw.Text(
                                      isDiscountInPercent
                                          ? "$discountValue %"
                                          : "$discountValue \$",
                                      style: pdfStyle),
                                ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Total Balance :" " ",
                                    style: pdfHeaderStyle),
                                pw.Text(
                                    // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
                                    //
                                    (cartModel.totalPrice +
                                            cartModel.previousBalance)
                                        .toStringAsFixed(2),
                                    style: pdfStyle),
                              ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Today's Payments :" " ",
                                    style: pdfHeaderStyle),
                                pw.Text(
                                    // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
                                    //
                                    cartModel.orderPaidAmount
                                        .toStringAsFixed(2),
                                    style: pdfStyle),
                              ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Remaining Balance :" " ",
                                    style: pdfHeaderStyle),
                                pw.Text(
                                    // Provider.of<HomeDashboardProvider>(ctx,listen: false).dashboard!.revenueData!.totalAmount.toString(),
                                    //
                                    cartModel.remainingBalance
                                        .toStringAsFixed(2),
                                    style: pdfStyle),
                              ]),
                        ]),
                  )),
            ),

            pw.SizedBox(height: 10),
            pw.Text(
                "Thank you for being a valued customer. We hope to serve you again in the near future."),
            pw.SizedBox(height: 8),
            pw.Text("Kind regards,"),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Row(children: [
                pw.Text("Invoice Created at :  "),
                pw.Text(getDate(DateTime.now().toString())),
                pw.SizedBox(width: 10),
                pw.Text(getTime(DateTime.now().toString())),
              ]),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  itemColumn(List<CustomRow> elements) {
    return pw.Column(
      children: [
        for (var element in elements)
          pw.Column(
              // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          element.name,
                        )),

                    // pw.Align(
                    //                     alignment: pw.Alignment.centerRight,
                    // )

                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        element.qnty,
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            (double.parse(element.price) *
                                    double.parse(element.qnty))
                                .toStringAsFixed(2),
                          )),
                    ),
                  ],
                ),
                // pw.Text(element.discription.isEmpty?"null":element.discription,
                //     style: pw.TextStyle(
                //       fontSize: 8,
                //       color: PdfColor.fromInt(0xFF1cbcb3),
                //     )),
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  height: 1,
                  color: PdfColor.fromInt(0x999999),
                ),
              ]),
      ],
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

  Future savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFilex.open(filePath);
    print(filePath);
    return filePath;
  }

  String getValue(num value) {
    if (value == 0.0) {
      return "0.0";
    } else {
      return value.toStringAsFixed(2);
    }
  }
}
