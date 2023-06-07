import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/sales%20rep/salesrep_order_page.dart';
import 'package:shop_app/services/add_review_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import '../customer/screens/cart/components/orders_invoice_pdf.dart';
import '../helper/custom_snackbar.dart';
import '../models/salesrep_orders_model.dart' hide OrderPayment;
import '../services/update_order_by_salesrep.dart';
import '../size_config.dart';
import '../widgets/multiline_custom_textfield.dart';

class OrdersDetailsPage extends StatefulWidget {
  final SaleRapOrdersList orders;
  final bool showScaffold;
  final bool isCustomer;

  const OrdersDetailsPage(
      {Key? key,
      required this.orders,
      required this.isCustomer,
      this.showScaffold = true})
      : super(key: key);

  @override
  State<OrdersDetailsPage> createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrdersDetailsPage> {
  @override
  void initState() {
    super.initState();

    log("widget.orders.status = ${widget.orders.status}");
  }

  TextEditingController reviewCont = TextEditingController();
  double rating = 5.0;

  LoginStorage storage = LoginStorage();

  @override
  Widget build(BuildContext context) {
    if (widget.showScaffold) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.orders.firstName ?? "",
            style: nameStyle,
          ),
          actions: [
            Text(
              getDate(widget.orders.dateTime) +
                  " " +
                  getTime(widget.orders.dateTime),
              style: timeStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SaleRepOrderDetailsWidget(
            orders: widget.orders,
          ),
        ),
        bottomNavigationBar: Container(
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
              if (widget.isCustomer && widget.orders.status != "Pending")
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              if (!widget.isCustomer)
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ),
      );
    } else {
      return SaleRepOrderDetailsWidget(orders: widget.orders);
    }
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

class SaleRepOrderDetailsWidget extends StatefulWidget {
  final SaleRapOrdersList orders;

  const SaleRepOrderDetailsWidget({Key? key, required this.orders})
      : super(key: key);

  @override
  State<SaleRepOrderDetailsWidget> createState() =>
      _SaleRepOrderDetailsWidgetState();
}

class _SaleRepOrderDetailsWidgetState extends State<SaleRepOrderDetailsWidget> {
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
              children: const [
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
                  "${widget.orders.orderId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            divider(),
            ListView.builder(
                itemCount: widget.orders.orderProducts!.length,
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
                        backgroundImage: NetworkImage(getImageUrl(widget.orders
                                .orderProducts![index].productImagePath ??
                            "")),
                      ),
                      title: Text(
                          widget.orders.orderProducts![index].productName ??
                              ""),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${widget.orders.orderProducts![index].quantity} × "),
                          Text(
                              "\$ ${widget.orders.orderProducts![index].price}"),
                        ],
                      ),
                    ),
                  );
                }),
            if (widget.orders.orderPayment!.isNotEmpty) divider(),
            if (widget.orders.orderPayment!.isNotEmpty)
              ListView.builder(
                itemCount: widget.orders.orderPayment!.length,
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
                            getPaymentMethodName(widget
                                .orders.orderPayment![index].paymentMethod!),
                            style: orderStyle,
                          ),
                          Text(
                            "${widget.orders.orderPayment![index].paymentAmount}",
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
                  widget.orders.previousBalance!.toStringAsFixed(2),
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
                  widget.orders.orderPaidAmount!.toStringAsFixed(2),
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
                  widget.orders.orderPendingPayment!.toStringAsFixed(2),
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
                  widget.orders.grandTotal!.toStringAsFixed(2),
                  style: orderStyle,
                )
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
