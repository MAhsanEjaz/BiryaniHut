import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/pdf_view_model.dart';
import 'package:shop_app/providers/account_balance_provider.dart';
import 'package:shop_app/services/pdf_invoice_services.dart';
import 'package:shop_app/services/update_customer_balance_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/storages/salesrep_cart_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import 'package:sumup/sumup.dart';
import '../../../components/default_button.dart';
import '../../../components/rounded_icon_btn.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../customer/screens/cart/components/payment_card.dart';
import '../providers/counter_provider.dart';
import '../services/account_balance_service.dart';
import '../services/add_to_cart_service.dart';

class SalesRepCartPage extends StatefulWidget {
  final int customerId;
  final String customerName;

  const SalesRepCartPage({
    Key? key,
    required this.customerId,
    required this.customerName,
  }) : super(key: key);

  @override
  State<SalesRepCartPage> createState() => _CustomerCartPageState();
}

class _CustomerCartPageState extends State<SalesRepCartPage> {
  // int selectedIndex = 0;
  List<CartItem> model = [];
  num totalDiscount = 0;
  num totalPrice = 0;
  num grandTotal = 0;

  // Uint8List? selectedImage;

  num previousBalance = 0;

  FocusNode amountNode = FocusNode();
  FocusNode chequeNoNode = FocusNode();
  FocusNode cashAppTransIdNode = FocusNode();

  // List<num> pricelist = [];
  // List<num> discountlist = [];
  SalesrepCartStorage cartStorage = SalesrepCartStorage();
  LoginStorage storage = LoginStorage();

  @override
  void initState() {
    if (cartStorage.getCartItems(customerId: widget.customerId) != null) {
      var list = cartStorage.getCartItems(customerId: widget.customerId);
      log("listlist = $list");
      list!.forEach((element) {
        model.add(CartItem.fromJson(json.decode(element)));
      });
      log("model length = ${model.length}");
    }

    //! calculate initial values
    model.forEach((element) {
      totalDiscount =
          totalDiscount + element.discount * element.quantity; //! needs testing
      totalPrice = totalPrice + element.price * element.quantity;
      log("totalPrice /// = $totalPrice");
    });
    super.initState();
    if (model.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        accountHandler();
      });
    }
  }

  accountHandler() async {
    CustomLoader.showLoader(context: context);
    await AccountBalanceService()
        .accountBalanceService(context: context, id: widget.customerId);
    CustomLoader.hideLoader(context);
  }

  updateCustomerBalanceHandler(
    //String? creditLmit
    int? id,
    num accountBalance,
  ) async {
    CustomLoader.showLoader(context: context);

    bool isUpdated = await UpdateCustmerBalanceService().updateCustomerBalance(
        context: context,
        accountBalance: double.parse(getRemainigBalance()),
        // creditLimit: creditLmit,
        customerId: id!);
    CustomLoader.hideLoader(context);

    if (isUpdated) {
      showToast("Balance Updated");
    } else {
      showToast("Balance could not be Updated");
    }
  }

  int selectedPaymentIndex = 0;

  PdfViewModel? model1;
  PdfInvoiceService pdfService = PdfInvoiceService();
  int number = 0;
  num totalPayable = 0;
  num totalPaid = 0;

  // num creditLimit = 0;

  TextEditingController amountCont = TextEditingController();
  TextEditingController chequeNo = TextEditingController();
  TextEditingController cashAppTransId = TextEditingController();

  // TextEditingController bankName = TextEditingController();
  // TextEditingController chequeImage = TextEditingController();
  // TextEditingController chequeExpiryDate = TextEditingController();
  // TextEditingController chequeTitle = TextEditingController();
  // DateTime selectedDate = DateTime.now();

  bool isOrderPlaced = false;

  List<String> paymentStringList = [];

  List<OrderPayment> paymentsList = [];

  addToCartHandler(String cart) async {
    CustomLoader.showLoader(context: context);
    isOrderPlaced =
        await AddToCartService().addToCart(context: context, cart: cart);
    CustomLoader.hideLoader(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // if (paymentsList.isNotEmpty) {
        //   showToast("Please order first");
        //   // CustomSnackBar.failedSnackBar(
        //   //     context: context, message: "Please order first");
        //   return Future.value(false);
        // } else {
        //   return Future.value(true);
        // }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                "${widget.customerName}'s Cart",
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                "${model.length} items",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            IconButton(
                tooltip: "Hold this order",
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.cancel_sharp,
                    size: 30,
                    // color: Colors.black,
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.length,
                  itemBuilder: (context, index) {
                    // final item = model[index];
                    // int quantity = item.quantity;
                    // model[index].quantity=;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                          key: Key(model[index].productId.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            num price =
                                model[index].price * model[index].quantity;

                            totalPrice = totalPrice - price;
                            model.removeAt(index);

                            cartStorage.deleteCartItem(
                                index: index, customerId: widget.customerId);
                            Provider.of<CartCounterProvider>(context,
                                    listen: false)
                                .setCount(model.length);
                            setState(() {
                              // updatePrices();
                            });
                          },
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 88,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        getProportionateScreenWidth(10)),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F6F9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    // child: Image.network(cart.product.images[0]),
                                    child: Image.network(model[index]
                                                    .productImagePath ==
                                                "" ||
                                            // ignore: unnecessary_null_comparison
                                            model[index].productImagePath ==
                                                null
                                        ? dummyImageUrl
                                        : getImageUrl(
                                            model[index].productImagePath)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    child: Text(
                                      model[index].productName,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text.rich(
                                    TextSpan(
                                      text: "\$${model[index].price}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: kPrimaryColor),
                                      children: [
                                        TextSpan(
                                            // text: " x${cart.numOfItem}",
                                            text: " x ${model[index].quantity}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        TextSpan(
                                            // text: " x${cart.numOfItem}",
                                            text: " = \$" +
                                                (model[index].price *
                                                        model[index].quantity)
                                                    .toStringAsFixed(2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RoundedIconBtn(
                                        icon: Icons.remove,
                                        showShadow: true,
                                        press: () {
                                          totalPrice = totalPrice -
                                              model[index].price *
                                                  model[index].quantity;

                                          model[index].quantity--;
                                          //! if quantity is less than 1 then remove item from cart
                                          if (model[index].quantity < 1) {
                                            cartStorage.deleteCartItem(
                                                index: index,
                                                customerId: widget.customerId);
                                            model.removeAt(index);
                                            Provider.of<CartCounterProvider>(
                                                    context,
                                                    listen: false)
                                                .decrementCount();
                                          } else {
                                            totalPrice = totalPrice +
                                                model[index].price *
                                                    model[index].quantity;

                                            cartStorage.updateCartItem(
                                                item: model[index],
                                                customerId: widget.customerId);
                                          }

                                          // updatePrices();
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(20)),
                                      RoundedIconBtn(
                                        icon: Icons.add,
                                        showShadow: true,
                                        press: () {
                                          totalPrice = totalPrice -
                                              model[index].price *
                                                  model[index].quantity;

                                          model[index].quantity++;
                                          cartStorage.updateCartItem(
                                              item: model[index],
                                              customerId: widget.customerId);

                                          totalPrice = totalPrice +
                                              model[index].price *
                                                  model[index].quantity;
                                          // updatePrices();

                                          setState(() {});

                                          log("quantity = ${model[index].quantity}");
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),

              if (model.isEmpty)
                const Center(
                  child: Text(
                    "Your Cart is empty yet",
                    style: nameStyle,
                  ),
                ),
              // if (model.isNotEmpty)
              if (paymentStringList.isNotEmpty)
                ListView.builder(
                  itemCount: paymentStringList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'assets/images/payment_done.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(paymentStringList[index],
                                  style: nameStyle)),
                        ],
                      ),
                    );
                  },
                ),

              if (model.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // SizedBox(
                      //   child: PaymentCard(
                      //     image: getSumupImageUrl(),
                      //     color: selectedPaymentIndex == 1 ? true : false,
                      //     onTap: () {
                      //       selectedPaymentIndex = 1;
                      //
                      //       handleSumupClick();
                      //       setState(() {});
                      //     },
                      //     paymentName: 'SumUp',
                      //   ),
                      // ),
                      //! payment by cash
                      PaymentCard(
                        image:
                            'https://st.depositphotos.com/1477399/1844/i/600/depositphotos_18442353-stock-photo-human-hands-exchanging-money.jpg',
                        color: selectedPaymentIndex == 2 ? true : false,
                        onTap: () {
                          selectedPaymentIndex = 2;
                          setState(() {});
                        },
                        paymentName: 'Cash',
                      ),

                      //! payment with cheque
                      PaymentCard(
                        image:
                            'https://img.freepik.com/premium-vector/man-holds-bank-check-with-signature-businessman-with-cheque-book-hand-payments-financial-operations_458444-434.jpg?w=360',
                        color: selectedPaymentIndex == 3 ? true : false,
                        onTap: () {
                          selectedPaymentIndex = 3;
                          setState(() {});
                        },
                        paymentName: 'Cheque',
                      ),

                      //! payment with cash app
                      PaymentCard(
                        image:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Square_Cash_app_logo.svg/1200px-Square_Cash_app_logo.svg.png',
                        color: selectedPaymentIndex == 4 ? true : false,
                        onTap: () {
                          selectedPaymentIndex = 4;
                          setState(() {});
                        },
                        paymentName: 'Cash App',
                      ),
                    ],
                  ),
                ),
              //! cash on delivery
              if (selectedPaymentIndex == 2) cashPaymentDesign(),

              //! cheque payment
              if (selectedPaymentIndex == 3) chequePaymentDesign(),

              //! cashapp payment payment

              if (selectedPaymentIndex == 4) cashAppPaymentDesign(),
            ],
          ),
        ),
        bottomNavigationBar: model.isNotEmpty &&
                Provider.of<AccountBalanceProvider>(context, listen: true)
                        .accountBalanceModel !=
                    null
            ? Consumer<AccountBalanceProvider>(builder: (context, data, _) {
                if (data.accountBalanceModel!.data!.creditLimit != null) {
                  print("Here Error");
                  // creditLimit = data.accountBalanceModel!.data!.creditLimit!;
                }

                ///Creating Issue
                previousBalance =
                    data.accountBalanceModel!.data!.accountBalance!;
                print("Previous Balance $previousBalance");

                // if (data.accountBalanceModel!.data!.accountBalance! < 0) {
                //   totalPayable =
                //       (data.accountBalanceModel!.data!.accountBalance!).abs();
                // } else {
                //   previousBalance =
                //       data.accountBalanceModel!.data!.accountBalance!;
                // }
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(15),
                    horizontal: getProportionateScreenWidth(30),
                  ),
                  // height: 174,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -15),
                        blurRadius: 20,
                        color: const Color(0xFFDADADA).withOpacity(0.15),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  openInvoice();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  height: getProportionateScreenWidth(40),
                                  width: getProportionateScreenWidth(40),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                      "assets/icons/receipt.svg"),
                                ),
                              ),
                              const Spacer(),
                              if (data.accountBalanceModel != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Previous Balance : \$ ${previousBalance.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // if (totalPayable > 0)
                                    //   Text(
                                    //     "Previous Payable : \$ ${totalPayable.toStringAsFixed(2)}",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    Text(
                                      "Today's Order Amount : \$ ${totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Total Balance: \$ " + getTotalBalance(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Today's Payment : \$ ${totalPaid.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Remaining Balance : \$ " +
                                          getRemainigBalance(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //! Total Paid
//(totalPrice - totalPaid)
                                    //! credit limit is working fine but it is removed due to client requirement
                                    //! changes
                                    // Text(
                                    //     "Credit Limit : \$ ${creditLimit.toStringAsFixed(2)}"),

                                    // if (totalPayable > 0)
                                    //   Text(
                                    //       "\$${totalPrice.toStringAsFixed(2)} + ${totalPayable.toStringAsFixed(2)} = " +
                                    //           getTotalPrice()),
                                  ],
                                )

                              // const SizedBox(width: 10),
                              // Icon(
                              //   Icons.arrow_forward_ios,
                              //   size: 12,
                              //   color: kTextColor,
                              // )
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text.rich(
                            //   TextSpan(
                            //     text: "Total:\n", //! total price
                            //     children: [
                            //       TextSpan(
                            //         // text: getTotalPrice(),
                            //         text: totalPrice.toStringAsFixed(2),

                            //         style: TextStyle(
                            //             fontSize: 16, color: Colors.black),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            DefaultButton(
                              text: "Check Out",
                              width: getProportionateScreenWidth(300),
                              press: () async {
                                // var box = Hive.box("salesrep_cart_box");
                                // try {
                                //   if (box.containsKey(
                                //       widget.customerId.toString() +
                                //           "salesrep_cart_list")) {
                                //     log("yes it  has key");
                                //   }
                                // } catch (e) {
                                //   log("message");
                                // }

                                // return;

                                showAwesomeAlert(
                                  context: context,
                                  msg: 'Do you want to place the order?',
                                  animType: AnimType.topSlide,
                                  dialogType: DialogType.info,
                                  onOkPress: () async {
                                    log("payment list = ${json.encode(paymentsList)}");

                                    if (isOrderPlaced) {
                                      showToast("This order already placed");
                                      Navigator.of(context).pop();
                                      return;
                                    }

                                    // num price = totalPrice +
                                    //     totalPayable -
                                    //     (totalPaid + previousBalance);

                                    // !following logic is commented because changed scenario of previous balance
                                    // if (totalPaid == 0 &&
                                    //     previousBalance > totalPrice) {
                                    //   totalPaid = totalPrice;
                                    //   log("totalPaid after conditions = $totalPaid");
                                    // }

                                    // if (price < 0 || price ) {
                                    //   canPlaceOrder = true;
                                    // }

                                    // log("creditLimit = $creditLimit");
                                    // log("price = $price");
                                    log("previousBalance = $previousBalance");
                                    // if (creditLimit < price) {
                                    //   showToast(
                                    //       "You can Order upto \$${creditLimit + previousBalance}");
                                    //   //! add awesome dialogue for this msg
                                    //   //! YOU CAN ONLY ORDER UPTO YOUR CREDIT LIMIT
                                    // } else {
                                    // num paid = 0;
                                    // num prevBlnc = previousBalance;
                                    // if (totalPaid >= totalPrice) {
                                    //   paid = totalPaid;
                                    //   prevBlnc =
                                    //       prevBlnc + (totalPaid - totalPrice);
                                    // } else {
                                    //   prevBlnc - totalPrice + totalPaid;
                                    // }
                                    // totalPaid =
                                    //     totalPaid + previousBalance - totalPrice;

                                    CartModel cartModel = CartModel(
                                      orderPayment: paymentsList,
                                      customerId: widget.customerId,
                                      dateTime: DateTime.now(),
                                      orderBy: 2,
                                      orderId: 0,
                                      orderProducts: model,
                                      discount: 0,
                                      grandTotal: totalPrice,
                                      status: 'Pending',
                                      totalPrice: totalPrice,
                                      orderPaidAmount: totalPaid,
                                      //! + previousBalance is removed in current scenario
                                      //! becasue totalbalance param is added in api
                                      orderPendingAmount:
                                          double.parse(getRemainigBalance()),
                                      remainingBalance:
                                          double.parse(getRemainigBalance()),
                                      totalBalance:
                                          double.parse(getTotalBalance()),
                                      previousBalance: previousBalance,
                                    );

                                    String jsonnn = cartModelToJson(cartModel);
                                    await addToCartHandler(jsonnn);
                                    log("jsonnn  /// = $jsonnn");
                                    if (isOrderPlaced) {
                                      await updateCustomerBalanceHandler(
                                        widget.customerId,
                                        getPreviousBalance(), //! setting it to 0 because previous balance was added into
                                        //! totalPaid and if total paid is more than total price then
                                        //! murtaza will again add this extra to customer's wallet
                                      );
                                      openInvoice();

                                      //! clearing full sales rep box
                                      //! because delete is not working for a particular key

                                      // Hive.box("salesrep_cart_box").clear();
                                      cartStorage.clearAnyCustomerCart(
                                          customerId: widget.customerId);

                                      // var box = Hive.box("salesrep_cart_box");
                                      // if (box.containsKey(
                                      //     widget.customerId.toString() +
                                      //         "salesrep_cart_list")) {
                                      //   log("yes it  has key");
                                      // }
                                      // box.delete(widget.customerId.toString() +
                                      //     "salesrep_cart_list");

                                      // box.compact();

                                      Provider.of<CartCounterProvider>(context,
                                              listen: false)
                                          .setCount(0);
                                    }

                                    if (isOrderPlaced) {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                child: ListView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    const SizedBox(height: 15),
                                                    SvgPicture.asset(
                                                      'assets/icons/checkout.svg',
                                                      color: appColor,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: Text(
                                                        '"Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      height: 45,
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // close bottom sheet and also navigate
                                                          // to previous page.
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Continue Shopping'),
                                                        style: ElevatedButton.styleFrom(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                appColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 30),
                                                  ],
                                                ),

                                                // color: Colors.black,
                                              ),
                                            );
                                          });
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
            : const SizedBox(),
      ),
    );
  }

  // String getTotalPrice() {
  //   num price = totalPrice + totalPayable - totalPaid;

  //   return price.toStringAsFixed(2);
  // }

  String getPreviousBalancePrice() {
    num price = previousBalance - totalPrice;

    return price.toStringAsFixed(2);
  }

  String getSumupImageUrl() {
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0FdJM8umSkq0hq-KyV6RYxl1LG7LWmMAdfg&usqp=CAU';
  }

  Future<void> handleSumupClick() async {
    var init = await Sumup.init("sup_afk_7bFSqnU1VA3FlagwNEA1Jw3XQU7NXwy");
    print(init);
    var login = await Sumup.login();
    var loginToken =
        await Sumup.loginWithToken("sup_afk_7bFSqnU1VA3FlagwNEA1Jw3XQU7NXwy");

    var settings = await Sumup.openSettings();
    var prepare = await Sumup.wakeUpTerminal();
    var payment = SumupPayment(
      title: 'Test payment',
      total: 1.2,
      currency: 'EUR',
      foreignTransactionId: '',
      saleItemsCount: 0,
      skipSuccessScreen: false,
      skipFailureScreen: true,
      tip: .0,
      customerEmail: null,
      customerPhone: null,
    );

    var request = SumupPaymentRequest(payment);
    var checkout = await Sumup.checkout(request);
    var isLogged = await Sumup.isLoggedIn;
    var isInProgress = await Sumup.isCheckoutInProgress;
    var merchant = await Sumup.merchant;
    // var logout = await Sumup.logout();
    // print(logout);
    print(merchant);
    print(isInProgress);
    print(isLogged);
    print(checkout);
    print(prepare);
    print(settings);
    print(login);
    print(loginToken);
    setState(() {});
  }

  Widget chequePaymentDesign() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
          child: CustomTextField(
            controller: chequeNo,
            focusNode: chequeNoNode,
            hint: "Cheque #",
            inputType: TextInputType.phone,
            isEnabled: true,
            prefixWidget: const Icon(Icons.numbers),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        //   child: CustomTextField(
        //     controller: chequeTitle,
        //     hint: "Title (pay for)",
        //     inputType: TextInputType.text,
        //     isEnabled: true,
        //     prefixWidget: Icon(Icons.person),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
          child: CustomTextField(
            controller: amountCont,
            focusNode: amountNode,
            hint: "Amount",
            inputType: TextInputType.number,
            isEnabled: true,
            prefixWidget: const Icon(Icons.monetization_on),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        //   child: InkWell(
        //     onTap: () {
        //       selectDate(context);
        //     },
        //     child: CustomTextField(
        //       controller: chequeExpiryDate,
        //       hint: "Expiry Date",
        //       isEnabled: false,
        //       prefixWidget: Icon(Icons.calendar_month),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        //   child: InkWell(
        //     onTap: () {
        //       handleImageSelection();
        //     },
        //     child: CustomTextField(
        //       controller: chequeImage,
        //       hint: "Attach Cheque Image (optional)",
        //       inputType: TextInputType.number,
        //       isEnabled: false,
        //       prefixWidget: Icon(Icons.image),
        //     ),
        //   ),
        // ),
        DefaultButton(
          buttonColor: appColor,
          press: () {
            if (chequeNo.text.isEmpty) {
              chequeNoNode.requestFocus();
              showAwesomeAlert(
                  context: context, msg: "Cheque No can't be empty");
              return;
            } else if (amountCont.text.trim().isEmpty) {
              amountNode.requestFocus();
              showAwesomeAlert(
                  context: context, msg: "Please Enter amount first");
              return;
            }
            totalPaid = totalPaid + double.parse(amountCont.text.trim());
            selectedPaymentIndex = 0;
            showToast("Cheque Cash Added");
            bool isPaymentFound = false;
            num totalByChequeCash = 0;
            if (paymentsList.isNotEmpty) {
              paymentsList.forEach((element) {
                if (element.paymentMethod == "7") {
                  element.paymentAmount = element.paymentAmount +
                      double.parse(amountCont.text.trim());
                  // element.chequeNo = chequeNo.text.trim();
                  // element.chequeExpiryDate = chequeExpiryDate.text;
                  // element.chequeFor = chequeTitle.text;
                  totalByChequeCash = element.paymentAmount;
                  isPaymentFound = true;
                  return;
                }
              });
            }

            if (isPaymentFound) {
              for (int i = 0; i < paymentStringList.length; i++) {
                if (paymentStringList[i].contains("Paid by Cheque")) {
                  paymentStringList.removeAt(i);
                }
              }
            } else {
              paymentsList.add(OrderPayment(
                  chequeNo: chequeNo.text.trim(),
                  // chequeExpiryDate: chequeExpiryDate.text,
                  // chequeFor: chequeTitle.text,
                  paymentMethod: "7",
                  paymentAmount: double.parse(amountCont.text.trim())));
              totalByChequeCash = double.parse(amountCont.text.trim());
            }

            paymentStringList.add("\$ $totalByChequeCash Paid by Cheque");
            amountCont.clear();
            chequeNo.clear();
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  cashAppPaymentDesign() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: CustomTextField(
            controller: cashAppTransId,
            focusNode: cashAppTransIdNode,
            hint: "Enter Transaction Id",
            inputType: TextInputType.text,
            isEnabled: true,
            prefixWidget: const Icon(Icons.numbers),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: CustomTextField(
            controller: amountCont,
            focusNode: amountNode,
            hint: "Add Amount",
            inputType: TextInputType.number,
            isEnabled: true,
            prefixWidget: const Icon(Icons.monetization_on),
          ),
        ),
        DefaultButton(
          buttonColor: appColor,
          press: () {
            if (amountCont.text.trim().isEmpty) {
              amountNode.requestFocus();
              showAwesomeAlert(
                  context: context, msg: "Please Enter amount first");
              return;
            }

            totalPaid = totalPaid + double.parse(amountCont.text.trim());
            selectedPaymentIndex = 0;
            showToast("Cash App payment Added ");
            bool isPaymentFound = false;
            num totalByCashApp = 0;
            if (paymentsList.isNotEmpty) {
              paymentsList.forEach((element) {
                if (element.paymentMethod == "8") {
                  element.paymentAmount = element.paymentAmount +
                      double.parse(amountCont.text.trim());
                  totalByCashApp = element.paymentAmount;
                  isPaymentFound = true;
                  return;
                }
              });
            }

            if (isPaymentFound) {
              for (int i = 0; i < paymentStringList.length; i++) {
                if (paymentStringList[i].contains("Paid by CashApp")) {
                  paymentStringList.removeAt(i);
                }
              }
            } else {
              paymentsList.add(OrderPayment(
                  paymentMethod: "8",
                  chequeNo: cashAppTransId.text, //! add transaction id here
                  paymentAmount: double.parse(amountCont.text.trim())));
              totalByCashApp = double.parse(amountCont.text.trim());
            }

            paymentStringList.add("\$ $totalByCashApp Paid by CashApp");
            amountCont.clear();
            cashAppTransId.clear();
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  Widget cashPaymentDesign() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: CustomTextField(
            controller: amountCont,
            focusNode: amountNode,
            hint: "Add Amount",
            inputType: TextInputType.number,
            isEnabled: true,
            prefixWidget: const Icon(Icons.monetization_on),
          ),
        ),
        DefaultButton(
          buttonColor: appColor,
          press: () {
            if (amountCont.text.trim().isEmpty) {
              amountNode.requestFocus();
              showAwesomeAlert(
                  context: context, msg: "Please Enter amount first");
              return;
            }

            totalPaid = totalPaid + double.parse(amountCont.text.trim());
            selectedPaymentIndex = 0;
            showToast("Cash Added ");
            bool isPaymentFound = false;
            num totalByCash = 0;
            if (paymentsList.isNotEmpty) {
              paymentsList.forEach((element) {
                if (element.paymentMethod == "1") {
                  element.paymentAmount = element.paymentAmount +
                      double.parse(amountCont.text.trim());
                  totalByCash = element.paymentAmount;
                  isPaymentFound = true;
                  return;
                }
              });
            }

            if (isPaymentFound) {
              for (int i = 0; i < paymentStringList.length; i++) {
                if (paymentStringList[i].contains("Paid by Cash")) {
                  paymentStringList.removeAt(i);
                }
              }
            } else {
              paymentsList.add(OrderPayment(
                  paymentMethod: "1",
                  chequeNo: chequeNo.text,
                  paymentAmount: double.parse(amountCont.text.trim())));
              totalByCash = double.parse(amountCont.text.trim());
            }

            paymentStringList.add("\$ $totalByCash Paid by Cash");
            amountCont.clear();
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  num getPreviousBalance() {
    log("getPreviousBalance/// totalPrice = $totalPrice");
    log("getPreviousBalance/// totalPayable = $totalPayable");
    log("getPreviousBalance/// totalPaid = $totalPaid");
    log("getPreviousBalance/// previousBalance = $previousBalance");
    num price = totalPrice - totalPayable - totalPaid - previousBalance;

    log("getPreviousBalance///  final price value = $price");
    if (price < 0) {
      // previousBalance = price.abs();

      return price.abs();
    } else {
      return 0;
    }
  }

  String getTotalBalance() {
    num totalBalance = 0;

    // totalBalance = previousBalance + totalPaid; //! before
    totalBalance = previousBalance + totalPrice;

    return totalBalance.toStringAsFixed(2);
  }

  String getRemainigBalance() {
    num remainigBalance = 0;

    // if (totalPaid + previousBalance > totalPayable + totalPrice) {
    //   remainigBalance = totalPaid + previousBalance - totalPayable - totalPrice;
    // } //! before remaining balance was the balance that will be available in customer's
    // !     account balance after order.
    //! but now this is balance that is payable for customer

    remainigBalance = double.parse(getTotalBalance()) - totalPaid;

    return remainigBalance.toStringAsFixed(2);
  }

  Future<void> openInvoice() async {
    CartModel cartModel = CartModel(
      orderPayment: paymentsList,
      customerId: widget.customerId,
      dateTime: DateTime.now(),
      orderBy: 2,
      orderId: 0,
      orderProducts: model,
      discount: 0,
      grandTotal: totalPrice,
      status: '',
      totalPrice: totalPrice,
      orderPaidAmount: totalPaid,
      orderPendingAmount: double.parse(getRemainigBalance()),
      remainingBalance: double.parse(getRemainigBalance()),
      totalBalance: double.parse(getTotalBalance()),
      previousBalance: previousBalance,
    );

    final data = await pdfService.createInvoice(
      ctx: context,
      cartModel: cartModel,
      customerName: widget.customerName,
      repName: storage.getUserFirstName() + " " + storage.getUserLastName(),
      isOrderCompleted: false,
    );

    pdfService.savePdfFile("invoice_$number", data);
    number++;
  }
}
