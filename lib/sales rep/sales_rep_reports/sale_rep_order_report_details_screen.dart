import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/sales%20rep/salesrep_order_page.dart';
import 'package:shop_app/services/add_review_service.dart';
import 'package:shop_app/services/salerep_order_report_details_service.dart';
import 'package:shop_app/services/update_order_by_salesrep.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/multiline_custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../customer/screens/cart/components/orders_invoice_pdf.dart';
import '../../models/order_report_details_model.dart';
import '../../models/salesrep_orders_model.dart';
import '../../providers/order_report_details_provider.dart';
import '../../providers/sale_rep_orders_provider.dart';
import '../../size_config.dart';
import '../order_detail_page.dart';

class SaleRepOrderReportDetailsScreen extends StatefulWidget {
  final int orderId;

  bool? isInvoices;
  bool? isCustomer;
  final String name;
  final String email;
  String phone;
  final String date;
  final SaleRapOrdersList orders;

  SaleRepOrderReportDetailsScreen(
      {Key? key,
      required this.orderId,
      required this.name,
      required this.email,
      this.isInvoices,
      required this.phone,
      this.isCustomer,
      required this.date,
      required this.orders})
      : super(key: key);

  @override
  State<SaleRepOrderReportDetailsScreen> createState() =>
      _SaleRepOrderReportDetailsScreenState();
}

class _SaleRepOrderReportDetailsScreenState
    extends State<SaleRepOrderReportDetailsScreen> {
  LoginStorage loginStorage = LoginStorage();

  repOrderReportDetailsHandler() async {
    CustomLoader.showLoader(context: context);
    await SaleRepOrderReportDetailsService()
        .getOrders(context: context, orderId: widget.orderId);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      repOrderReportDetailsHandler();
      log("orderid in salesrep orders report detail page = ${widget.orderId}");
    });
    super.initState();
  }

  Future<String> _savePDF(String fileName, List<int> data) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String filePath = '$tempPath/$fileName.pdf';

    final File file = File(filePath);
    await file.writeAsBytes(data);

    return filePath;
  }

  void sendSms(String message) async {
    // const message = 'Hello from!';
    String formattedPhoneNumber = widget.phone.replaceAll('-', '');
    final url =
        'sms:"$formattedPhoneNumber"?body=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendEmail(List<String> path) async {
    final Email email = Email(
      body: 'A new order has been placed with Order ID ${widget.orderId} ',
      subject: 'Influence',
      recipients: [widget.email],
      // cc: [widget.email],
      // bcc: [widget.email],
      attachmentPaths: path,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderReportDetailsProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: nameStyle,
          ),
          actions: [
            Text(
              getDate(widget.date) + " " + getTime(widget.date),
              style: timeStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<OrderReportDetailsProvider>(
                    builder: (context, order, _) {
                  return order.reportDetailsModel != null
                      ? OrderReportDetailsWidget(
                          orders: order.reportDetailsModel!,
                        )
                      : const SizedBox();
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: appColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          showCupertinoDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => AlertDialog(
                                  content: StatefulBuilder(
                                      builder: (context, Setstate) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.sms),
                                                onTap: () {
                                                  for (var element in data
                                                      .reportDetailsModel!
                                                      .data!
                                                      .orderProducts) {
                                                    sendSms(
                                                      'Order Id : ${element.productId}\nProduct Name: ${element.productName}\nTotal Price: ${element.totalPrice}\nQuantity: ${element.quantity}\n',
                                                    );
                                                  }
                                                },
                                                title: const Text('Message'),
                                              ),
                                              ListTile(
                                                  leading:
                                                      const Icon(Icons.mail),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    final data =
                                                        await PdfOrdersInvoiceService()
                                                            .createInvoice(
                                                      ctx: context,
                                                      order: widget.orders,
                                                      customerName: widget
                                                              .orders
                                                              .firstName! +
                                                          " " +
                                                          widget
                                                              .orders.lastName!,
                                                      isOrderCompleted: widget
                                                                  .orders
                                                                  .status ==
                                                              "Pending"
                                                          ? false
                                                          : true,
                                                      repName: storage
                                                              .getUserFirstName() +
                                                          " " +
                                                          storage
                                                              .getUserLastName(),
                                                    );

                                                    final filePath =
                                                        await _savePDF(
                                                            "Influance Invoice",
                                                            data);

                                                    _sendEmail([filePath]);
                                                  },
                                                  title: const Text('Gmail')),
                                            ],
                                          ))));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 10),
                            Text("Share")
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: widget.isInvoices == true
            ? InkWell(
                onTap: () async {
                  String repName = '';
                  if (storage.getUsertype() == "customer") {
                    repName = storage.getSalesRepName();
                  } else {
                    repName = storage.getUserFirstName() +
                        " " +
                        storage.getUserLastName();
                  }
                  final data = await PdfOrdersInvoiceService().createInvoice(
                    ctx: context,
                    order: widget.orders,
                    customerName: widget.orders.firstName! +
                        " " +
                        widget.orders.lastName!,
                    repName: repName,
                    isOrderCompleted:
                        widget.orders.status == "Pending" ? false : true,
                  );

                  PdfOrdersInvoiceService()
                      .savePdfFile("Influance Invoice", data);
                  // number++;

                  //test

                  // final file = await PdfService().generatePdf();

                  // Open the PDF file
                  // await OpenFilex.open(file.path);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: getProportionateScreenWidth(40),
                    width: getProportionateScreenWidth(120),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/receipt.svg",
                          color: appColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Invoice",
                          style: TextStyle(
                            color: appColor,
                            // fontSize: 14.0,
                            // fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : widget.isCustomer == true
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: lightBlackColor, width: 1.5)),
                    height: kToolbarHeight * 1.0,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            String repName = '';
                            if (storage.getUsertype() == "customer") {
                              repName = storage.getSalesRepName();
                            } else {
                              repName = storage.getUserFirstName() +
                                  " " +
                                  storage.getUserLastName();
                            }
                            final data =
                                await PdfOrdersInvoiceService().createInvoice(
                              ctx: context,
                              order: widget.orders,
                              customerName: widget.orders.firstName! +
                                  " " +
                                  widget.orders.lastName!,
                              repName: repName,
                              isOrderCompleted:
                                  widget.orders.status == "Pending"
                                      ? false
                                      : true,
                            );

                            PdfOrdersInvoiceService()
                                .savePdfFile("Influance Invoice", data);
                            // number++;

                            //test

                            // final file = await PdfService().generatePdf();

                            // Open the PDF file
                            // await OpenFilex.open(file.path);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: getProportionateScreenWidth(40),
                            width: getProportionateScreenWidth(120),
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/receipt.svg",
                                  color: appColor,
                                ),
                                const Text(
                                  "Invoice",
                                  style: TextStyle(
                                    color: appColor,
                                    // fontSize: 14.0,
                                    // fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (widget.isCustomer! &&
                            widget.orders.status != "Pending")
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            height: getProportionateScreenWidth(42),
                            width: getProportionateScreenWidth(120),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.redAccent),
                            child: InkWell(
                              onTap: () {
                                showSheetForReview();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.orders.status != "Pending"
                                      ? const Icon(
                                          Icons.edit,
                                          color: whiteColor,
                                        )
                                      : const SizedBox(),
                                  const Text("Add Review",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        if (!widget.isCustomer!)
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            height: getProportionateScreenWidth(42),
                            width: getProportionateScreenWidth(120),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.orders.status == "Pending"
                                    ? Colors.redAccent
                                    : Colors.greenAccent),
                            child: InkWell(
                              onTap: () {
                                if (widget.orders.status == "Pending") {
                                  showAwesomeAlert(
                                    context: context,
                                    msg: "Is the order delivery completed?",
                                    animType: AnimType.bottomSlide,
                                    dialogType: DialogType.info,
                                    onOkPress: () {
                                      updateOrderHandler();
                                    },
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.orders.status != "Pending"
                                      ? const Icon(
                                          Icons.check_circle_outline_sharp,
                                          color: whiteColor,
                                        )
                                      : const SizedBox(),
                                  Text(
                                      widget.orders.status == "Pending"
                                          ? "Order Pending"
                                          : widget.orders.status!,
                                      style: const TextStyle(
                                          // height: 0.9,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : widget.isCustomer == false
                    ? Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: lightBlackColor, width: 1.5)),
                            height: kToolbarHeight * 1.0,
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final data = await PdfOrdersInvoiceService()
                                        .createInvoice(
                                            ctx: context,
                                            order: widget.orders,
                                            customerName:
                                                widget.orders.firstName! +
                                                    " " +
                                                    widget.orders.lastName!,
                                            isOrderCompleted:
                                                widget.orders.status ==
                                                        "Pending"
                                                    ? false
                                                    : true,
                                            repName:
                                                storage.getUserFirstName() +
                                                    " " +
                                                    storage.getUserLastName());

                                    PdfOrdersInvoiceService()
                                        .savePdfFile("Influance Invoice", data);
                                    // number++;

                                    //test

                                    // final file = await PdfService().generatePdf();

                                    // Open the PDF file
                                    // await OpenFilex.open(file.path);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: getProportionateScreenWidth(40),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: appColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/receipt.svg",
                                          color: appColor,
                                        ),
                                        const Text(
                                          "Invoice",
                                          style: TextStyle(
                                            color: appColor,
                                            // fontSize: 14.0,
                                            // fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (widget.isCustomer! &&
                                    widget.orders.status != "Pending")
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    height: getProportionateScreenWidth(42),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.redAccent),
                                    child: InkWell(
                                      onTap: () {
                                        showSheetForReview();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.orders.status != "Pending"
                                              ? const Icon(
                                                  Icons.edit,
                                                  color: whiteColor,
                                                )
                                              : const SizedBox(),
                                          const Text("Add Review",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (!widget.isCustomer!)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    height: getProportionateScreenWidth(42),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: widget.orders.status == "Pending"
                                            ? Colors.redAccent
                                            : Colors.greenAccent),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.orders.status == "Pending") {
                                          showAwesomeAlert(
                                            context: context,
                                            msg:
                                                "Is the order delivery completed?",
                                            animType: AnimType.bottomSlide,
                                            dialogType: DialogType.info,
                                            onOkPress: () {
                                              updateOrderHandler();
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.orders.status != "Pending"
                                              ? const Icon(
                                                  Icons
                                                      .check_circle_outline_sharp,
                                                  color: whiteColor,
                                                )
                                              : const SizedBox(),
                                          Text(
                                              widget.orders.status == "Pending"
                                                  ? "Order Pending"
                                                  : widget.orders.status!,
                                              style: const TextStyle(
                                                  // height: 0.9,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: lightBlackColor, width: 1.5)),
                            height: kToolbarHeight * 1.0,
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final data = await PdfOrdersInvoiceService()
                                        .createInvoice(
                                      ctx: context,
                                      order: widget.orders,
                                      customerName: widget.orders.firstName! +
                                          " " +
                                          widget.orders.lastName!,
                                      repName: storage.getUserFirstName() +
                                          " " +
                                          storage.getUserLastName(),
                                      isOrderCompleted:
                                          widget.orders.status == "Pending"
                                              ? false
                                              : true,
                                    );

                                    PdfOrdersInvoiceService()
                                        .savePdfFile("Influance Invoice", data);
                                    // number++;

                                    //test

                                    // final file = await PdfService().generatePdf();

                                    // Open the PDF file
                                    // await OpenFilex.open(file.path);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: getProportionateScreenWidth(40),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: appColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/receipt.svg",
                                          color: appColor,
                                        ),
                                        const Text(
                                          "Invoice",
                                          style: TextStyle(
                                            color: appColor,
                                            // fontSize: 14.0,
                                            // fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (widget.isCustomer! &&
                                    widget.orders.status != "Pending")
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    height: getProportionateScreenWidth(42),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.redAccent),
                                    child: InkWell(
                                      onTap: () {
                                        showSheetForReview();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.orders.status != "Pending"
                                              ? const Icon(
                                                  Icons.edit,
                                                  color: whiteColor,
                                                )
                                              : const SizedBox(),
                                          const Text("Add Review",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (!widget.isCustomer!)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    height: getProportionateScreenWidth(42),
                                    width: getProportionateScreenWidth(120),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: widget.orders.status == "Pending"
                                            ? Colors.redAccent
                                            : Colors.greenAccent),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.orders.status == "Pending") {
                                          showAwesomeAlert(
                                            context: context,
                                            msg:
                                                "Is the order delivery completed?",
                                            animType: AnimType.bottomSlide,
                                            dialogType: DialogType.info,
                                            onOkPress: () {
                                              updateOrderHandler();
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.orders.status != "Pending"
                                              ? const Icon(
                                                  Icons
                                                      .check_circle_outline_sharp,
                                                  color: whiteColor,
                                                )
                                              : const SizedBox(),
                                          Text(
                                              widget.orders.status == "Pending"
                                                  ? "Order Pending"
                                                  : widget.orders.status!,
                                              style: const TextStyle(
                                                  // height: 0.9,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: kToolbarHeight * 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          height: getProportionateScreenWidth(40),
                          decoration: BoxDecoration(
                            border: Border.all(color: appColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final data = await PdfOrdersInvoiceService()
                                      .createInvoice(
                                    ctx: context,
                                    order: widget.orders,
                                    customerName: widget.name,
                                    repName: loginStorage.getUserFirstName() +
                                        " " +
                                        loginStorage.getUserLastName(),
                                    isOrderCompleted:
                                        widget.orders.status == "Pending"
                                            ? false
                                            : true,
                                  );

                                  PdfOrdersInvoiceService()
                                      .savePdfFile("Influance Invoice", data);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: getProportionateScreenHeight(35.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appColor, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/receipt.svg",
                                        color: appColor,
                                      ),
                                      const Text(
                                        "Generate Invoice",
                                        style: TextStyle(
                                          color: appColor,
                                          // fontSize: 14.0,
                                          // fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
      );
    });
  }

  Future<void> updateOrderHandler() async {
    // Map<String, dynamic> body = {
    // "payments": paymentsList,
    // "orderId": widget.orders.orderId,
    // "totalAmount": totalPaid
    // };

    CustomLoader.showLoader(context: context);

    bool isUpdated = await UpdateOrderBySalesrepService().updateOrderBySalesrep(
        context: context, orderId: widget.orders.orderId!);

    CustomLoader.hideLoader(context);

    if (isUpdated) {
      CustomSnackBar.showSnackBar(
          context: context, message: "Order Updated Successfully");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SalesrepOrdersPage(),
          ));
    } else {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Order Could not be Updated");
    }
  }

  void showSheetForReview() {
    showModalBottomSheet(
      isScrollControlled: true,
      // isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  height: 50,
                  color: appColor,
                  width: SizeConfig.screenWidth,
                  child: const Center(
                      child: Text(
                    "Review & Rating",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MultilineCustomTextField(
                  isEnabled: true,
                  maxlines: 4,
                  minlines: 3,
                  controller: reviewCont,
                  hint: "Write review here...",
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  glow: true,
                  glowColor: appColor,
                  updateOnDrag: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    log(rating.toString());
                    rating = newRating;
                  },
                ),
              ),
              DefaultButton(
                text: "Submit Review",
                width: getProportionateScreenWidth(200),
                press: () {
                  Navigator.pop(context);
                  addReviewHandler();
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        );
      },
    );
  }

  TextEditingController reviewCont = TextEditingController();
  double rating = 5.0;

  LoginStorage storage = LoginStorage();

  Future<void> addReviewHandler() async {
    final body = {
      "ratingId": 0,
      "comments": reviewCont.text,
      "rating": rating,
      "ratingDate": DateTime.now().toIso8601String(),
      "orderId": widget.orders.orderId,
      "customerId": LoginStorage().getUserId(),
      // "saleRepId": 0
    };

    CustomLoader.showLoader(context: context);
    bool isAdded = await AddCustomerOrderReviewService()
        .addCustomerOrderReview(context: context, body: body);
    CustomLoader.hideLoader(context);

    if (isAdded) {
      CustomSnackBar.showSnackBar(
          context: context, message: "Review Added Successfully");
    } else {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Review could not be added");
    }
  }
}

class OrderReportDetailsWidget extends StatefulWidget {
  OrderReportDetailsModel orders;

  OrderReportDetailsWidget({required this.orders});

  @override
  State<OrderReportDetailsWidget> createState() =>
      _OrderReportDetailsWidgetState();
}

class _OrderReportDetailsWidgetState extends State<OrderReportDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Details",
                  style: detailsStyle,
                ),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Order Id : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.orders.data!.orderId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            divider(),
            ListView.builder(
                itemCount: widget.orders.data!.orderProducts.length,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                // primary: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.orders.data!
                            .orderProducts[index].productImagePath!),
                      ),
                      title: Text(
                          widget.orders.data!.orderProducts[index].productName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${widget.orders.data!.orderProducts[index].quantity} × "),
                          Text(
                              "\$ ${widget.orders.data!.orderProducts[index].price}"),
                        ],
                      ),
                    ),
                  );
                }),
            if (widget.orders.data!.orderPayment.isNotEmpty) divider(),
            if (widget.orders.data!.orderPayment.isNotEmpty)
              ListView.builder(
                itemCount: widget.orders.data!.orderPayment.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == 0)
                        const Text(
                          "Payment Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getPaymentMethodName(widget.orders.data!
                                .orderPayment[index].paymentMethod),
                            style: orderStyle,
                          ),
                          Text(
                            "${widget.orders.data!.orderPayment[index].paymentAmount}",
                            style: orderStyle,
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Previous Balance",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.previousBalance.toStringAsFixed(2),
                  style: orderStyle,
                )
              ],
            ),
            divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Payment", //  "Total Paid",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.orderPaidAmount.toStringAsFixed(2),
                  style: orderStyle,
                )
              ],
            ),
            divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Remaining Balance",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.orderPendingPayment.toStringAsFixed(2),
                  style: orderStyle,
                )
              ],
            ),
            divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Order's Amount",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.grandTotal.toStringAsFixed(2),
                  style: orderStyle,
                )
              ],
            ),Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discount",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.discount.toStringAsFixed(2),
                  style: orderStyle,
                ),

              ],
            ),

            Divider(),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discount",
                  style: orderStyle,
                ),
                Text(
                  widget.orders.data!.netTotal.toStringAsFixed(2),
                  style: orderStyle,
                ),

              ],
            ),


          ],
        ),
      ),
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
}
