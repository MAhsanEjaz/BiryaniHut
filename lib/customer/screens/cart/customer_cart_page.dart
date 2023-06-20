import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/customer/screens/cart/components/google_play_button.dart';
import 'package:shop_app/customer/screens/cart/components/payment_card.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/pdf_view_model.dart';
import 'package:shop_app/providers/customer_profile_provider.dart';
import 'package:shop_app/providers/salesrep_discount_provider.dart';
import 'package:shop_app/services/add_to_cart_service.dart';
import 'package:shop_app/services/get_salesrep_discount_service.dart';
import 'package:shop_app/services/pdf_invoice_services.dart';
import 'package:shop_app/storages/customer_cart_storage.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import '../../../components/common_widgets.dart';
import '../../../components/default_button.dart';
import '../../../components/rounded_icon_btn.dart';
import '../../../constants.dart';
import '../../../models/salesrep_get_discount_model.dart';
import '../../../providers/account_balance_provider.dart';
import '../../../providers/counter_provider.dart';
import '../../../services/account_balance_service.dart';
import '../../../services/customer_get_profile_service.dart';
import '../../../services/update_customer_balance_service.dart';
import '../../../size_config.dart';

class CustomerCartPage extends StatefulWidget {
  const CustomerCartPage({Key? key}) : super(key: key);

  @override
  State<CustomerCartPage> createState() => _CustomerCartPageState();
}

class _CustomerCartPageState extends State<CustomerCartPage> {
  int selectedIndex = 0;
  List<CartItem> model = [];
  num totalDiscount = 0;
  num totalPrice = 0;
  num grandTotal = 0;
  SalesrepDiscountModel? repDiscountModel;
  bool isDiscountInPercent = false;
  bool isDiscountApplicable = false;

  TextEditingController amountCont = TextEditingController();

  LoginStorage loginStorage = LoginStorage();
  int cartItemsCount = 0;

  int selectedPaymentIndex = 0;

  CustomerCartStorage cartStorage = CustomerCartStorage();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customerGetDataHandler();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRepDiscountHandler();
    });

    if (cartStorage.getCartItems() != null) {
      var list = cartStorage.getCartItems();
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

      cartItemsCount = cartItemsCount + element.quantity;

      log("new items count = $cartItemsCount");
    });
    if (model.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        accountHandler();
      });
    }
    if (cartItemsCount >= 20) {
      isDiscountApplicable = true;
    }

    log('isDiscountApplicable = $isDiscountApplicable');
    log('cartItemsCount = $cartItemsCount');
  }

  List<OrderPayment> paymentsList = [];
  List<String> paymentStringList = [];
  num previousBalance = 0;
  num totalPaid = 0;
  num totalPayable = 0;

  bool isOrderPlaced = false;

  FocusNode amountNode = FocusNode();
  FocusNode chequeNoNode = FocusNode();
  FocusNode cashAppTransIdNode = FocusNode();

  TextEditingController chequeNo = TextEditingController();
  TextEditingController cashAppTransId = TextEditingController();

  bool switchTime = false;

  Map<String, dynamic>? paymentIntentData;
  PdfViewModel? model1;
  PdfInvoiceService pdfService = PdfInvoiceService();
  int number = 0;

  // String stripePaymentString = '';
  // String paypalPaymentString = '';
  // String googleOrApplePaymentString = '';
  // String cashAppPaymentString = '';

  Future<void> getRepDiscountHandler() async {
    CustomLoader.showLoader(context: context);
    await SalesrepGetDiscountService().getRepDiscount(context: context);

    CustomLoader.hideLoader(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SalesrepDiscountProvider, CustomerProfileProvider>(
        builder: (context, data, customer, _) {
      repDiscountModel = data.repDiscountModel;
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "${model.length} items",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

                    // log("image url = ${model[index].productImagePath}");

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
                            cartStorage.deleteCartItem(index: index);
                            Provider.of<CartCounterProvider>(context,
                                    listen: false)
                                .decrementCount();
                            updateIsDiscountApplicable();
                            setState(() {});
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
                                                    .productImage ==
                                                "" ||
                                            // ignore: unnecessary_null_comparison
                                            model[index].productImage == null
                                        ? dummyImageUrl
                                        : getImageUrl(
                                            model[index].productImage)),
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
                                                index: index);
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
                                                item: model[index]);
                                          }
                                          updateIsDiscountApplicable();

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
                                              item: model[index]);

                                          totalPrice = totalPrice +
                                              model[index].price *
                                                  model[index].quantity;
                                          // updatePrices();
                                          updateIsDiscountApplicable();

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

              if (model.isEmpty)
                const Center(
                  child: Text(
                    "Your Cart is empty yet",
                    style: nameStyle,
                  ),
                ),
              if (model.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        //! payment by cash
                        PaymentCard(
                          image:
                              'https://st.depositphotos.com/1477399/1844/i/600/depositphotos_18442353-stock-photo-human-hands-exchanging-money.jpg',
                          color: selectedPaymentIndex == 1 ? true : false,
                          onTap: () {
                            selectedPaymentIndex = 1;
                            setState(() {});
                          },
                          paymentName: 'Cash',
                        ),

                        //! payment with cheque
                        PaymentCard(
                          image:
                              'https://img.freepik.com/premium-vector/man-holds-bank-check-with-signature-businessman-with-cheque-book-hand-payments-financial-operations_458444-434.jpg?w=360',
                          color: selectedPaymentIndex == 2 ? true : false,
                          onTap: () {
                            selectedPaymentIndex = 2;
                            setState(() {});
                          },
                          paymentName: 'Cheque',
                        ),

                        //! payment with cash app
                        PaymentCard(
                          image:
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Square_Cash_app_logo.svg/1200px-Square_Cash_app_logo.svg.png',
                          color: selectedPaymentIndex == 3 ? true : false,
                          onTap: () {
                            selectedPaymentIndex = 3;
                            setState(() {});
                          },
                          paymentName: 'Cash App',
                        ),

                        PaymentCard(
                          image:
                              'http://assets.stickpng.com/thumbs/62a382de6209494ec2b17086.png',
                          color: selectedPaymentIndex == 4 ? true : false,
                          onTap: () {
                            selectedPaymentIndex = 4;
                            setState(() {});
                          },
                          paymentName: 'Stripe',
                        ),

                        // PaymentCard(
                        //   image:
                        //       'https://cdn.pixabay.com/photo/2018/05/08/21/29/paypal-3384015_1280.png',
                        //   color: selectedPaymentIndex == 5 ? true : false,
                        //   onTap: () {
                        //     selectedPaymentIndex = 5;
                        //     setState(() {});
                        //   },
                        //   paymentName: 'Paypal',
                        // ),

                        // Column(
                        //   children: [
                        //     const Text('G-Pay'),
                        //     const GooglePlayButtonCard(),
                        //   ],
                        // )

                        // PaymentCard(
                        //   image:
                        //       'https://cdn.pixabay.com/photo/2018/05/08/21/29/paypal-3384015_1280.png',
                        //   color: selectedPaymentIndex == 5 ? true : false,
                        //   onTap: () {
                        //     selectedPaymentIndex = 5;
                        //     setState(() {});
                        //   },
                        //   paymentName: 'Paypal',
                        // ),
                      ],
                    ),
                  ),
                ),
              //! cash on delivery
              if (selectedPaymentIndex == 1) cashPaymentDesign(),

              //! cheque payment
              if (selectedPaymentIndex == 2) chequePaymentDesign(),

              //! cashapp payment payment

              if (selectedPaymentIndex == 3) cashAppPaymentDesign(),
              //! stripe payment payment

              if (selectedPaymentIndex == 4) stripePaymentMethod(),
              //! paypal payment payment

              // if (selectedPaymentIndex == 5) payPalPaymentMethod(),
            ],
          ),
        ),
        bottomNavigationBar: model.isNotEmpty &&
                Provider.of<AccountBalanceProvider>(context, listen: true)
                        .accountBalanceModel !=
                    null
            ? Consumer<AccountBalanceProvider>(builder: (context, data, _) {
                if (data.accountBalanceModel!.data!.creditLimit != null) {
                  log("Here Error");
                  // creditLimit = data.accountBalanceModel!.data!.creditLimit!;
                }

                ///Creating Issue
                previousBalance =
                    data.accountBalanceModel!.data!.accountBalance!;
                log("Previous Balance $previousBalance");

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
                              Column(
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
                                  const Text("Invoice")
                                ],
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
                                    //   ),di

                                    if (repDiscountModel != null &&
                                        isDiscountApplicable)
                                      Text(
                                        "Today's Order Amount : \$ " +
                                            totalPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (repDiscountModel != null &&
                                        isDiscountApplicable)
                                      Text(
                                        "Discount in ${isDiscountInPercent ? 'Percent' : 'Dollar'} : \$ ${repDiscountModel!.data.discount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    Text(
                                      "Order Payable Amount : \$ " +
                                          getOrderAmount(),
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
                                  var res = customer.customerProfileModel;

                                  res!.data!.saleRep?.id == null
                                      ? showAwesomeAlert(
                                          context: context,
                                          msg:
                                              "Approval for creation of your account is in process. We will let you know as soon as it is completed.",
                                          okBtnText: 'Ok',
                                          cancelBtnText: 'Cancel',
                                          onCancelPress: () {
                                            customerGetDataHandler();
                                          },
                                          onOkPress: () {
                                            customerGetDataHandler();
                                          })
                                      :

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
                                          msg:
                                              'Do you want to place the order?',
                                          animType: AnimType.topSlide,
                                          dialogType: DialogType.info,
                                          onOkPress: () async {
                                            log("payment list = ${json.encode(paymentsList)}");

                                            if (isOrderPlaced) {
                                              showToast(
                                                  "This order already placed");
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
                                              netTotal: double.parse(
                                                  getOrderAmount()),
                                              orderPayment: paymentsList,
                                              customerId:
                                                  loginStorage.getUserId(),
                                              dateTime: DateTime.now(),
                                              orderBy: 1,
                                              orderId: 0,
                                              orderProducts: model,
                                              discount: isDiscountApplicable
                                                  ? repDiscountModel!
                                                      .data.discount
                                                  : 0,
                                              grandTotal: totalPrice,
                                              status: 'Pending',
                                              totalPrice: totalPrice,
                                              orderPaidAmount: totalPaid,
                                              //! + previousBalance is removed in current scenario
                                              //! becasue totalbalance param is added in api
                                              orderPendingAmount: double.parse(
                                                  getRemainigBalance()),
                                              remainingBalance: double.parse(
                                                  getRemainigBalance()),
                                              totalBalance: double.parse(
                                                  getTotalBalance()),
                                              previousBalance: previousBalance,
                                              discountType:
                                                  isDiscountApplicable &&
                                                          isDiscountInPercent
                                                      ? "By Percentage"
                                                      : "By Value",
                                            );

                                            String jsonnn =
                                                cartModelToJson(cartModel);
                                            await addToCartHandler(jsonnn);
                                            log("jsonnn  /// = $jsonnn");
                                            if (isOrderPlaced) {
                                              await updateCustomerBalanceHandler(
                                                loginStorage.getUserId(),
                                                getPreviousBalance(), //! setting it to 0 because previous balance was added into
                                                //! totalPaid and if total paid is more than total price then
                                                //! murtaza will again add this extra to customer's wallet
                                              );
                                              openInvoice();

                                              //! clearing full sales rep box
                                              //! because delete is not working for a particular key

                                              Hive.box("customer_cart_box")
                                                  .clear();

                                              Provider.of<CartCounterProvider>(
                                                      context,
                                                      listen: false)
                                                  .setCount(0);
                                            }

                                            if (isOrderPlaced) {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: ListView(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          children: [
                                                            const SizedBox(
                                                                height: 15),
                                                            SvgPicture.asset(
                                                              'assets/icons/checkout.svg',
                                                              color: appColor,
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
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
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              height: 45,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // close bottom sheet and also navigate
                                                                  // to previous page.
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    'Continue Shopping'),
                                                                style: ElevatedButton.styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    backgroundColor:
                                                                        appColor,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 30),
                                                          ],
                                                        ),

                                                        // color: Colors.black,
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
            : const SizedBox(),
      );
    });
  }

  accountHandler() async {
    CustomLoader.showLoader(context: context);
    await AccountBalanceService()
        .accountBalanceService(context: context, id: loginStorage.getUserId());
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

  Future<bool> addToCartHandler(String cart) async {
    CustomLoader.showLoader(context: context);
    isOrderPlaced =
        await AddToCartService().addToCart(context: context, cart: cart);
    CustomLoader.hideLoader(context);
    return isOrderPlaced;
  }

  String getTotalPrice() {
    num price = totalPrice - previousBalance;
    return price.toStringAsFixed(2);
  }

  Future<void> makePayment(
    String amount,
  ) async {
    try {
      paymentIntentData = await createPaymentIntent(
        double.parse(amountCont.text).round().toString(),
        'USD',
      );
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  // // applePay: true,
                  // // googlePay: true,
                  // testEnv: false,
                  style: ThemeMode.system,
                  // appearance: PaymentSheetAppearance(
                  //     colors: PaymentSheetAppearanceColors(
                  //         primary: Colors.black,
                  //         background: Colors.orange[100])),
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Payment Successful")));

        // totalPrice = totalPrice -
        // double.parse(amount);

        totalPaid = totalPaid + double.parse(amountCont.text.trim());
        selectedPaymentIndex = 0;
        showToast("Stripe Payment Added");
        bool isPaymentFound = false;
        num totalByCash = 0;
        if (paymentsList.isNotEmpty) {
          paymentsList.forEach((element) {
            if (element.paymentMethod == "2") {
              element.paymentAmount =
                  element.paymentAmount + double.parse(amountCont.text.trim());
              totalByCash = element.paymentAmount;
              isPaymentFound = true;
              return;
            }
          });
        }

        if (isPaymentFound) {
          for (int i = 0; i < paymentStringList.length; i++) {
            if (paymentStringList[i].contains("Paid by Stripe")) {
              paymentStringList.removeAt(i);
            }
          }
        } else {
          paymentsList.add(OrderPayment(
              paymentMethod: "2",
              chequeNo: chequeNo.text,
              paymentAmount: double.parse(amountCont.text.trim())));
          totalByCash = double.parse(amountCont.text.trim());
        }

        paymentStringList.add("\$ $totalByCash Paid by Stripe");
        amountCont.clear();
        FocusScope.of(context).unfocus();
        setState(() {});

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

//  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JUUldDdNsnMpgdhx8kWqPhfiqHAHUVcd0BDw48M5HiP5GF36hOROHX2A2kq5BxYrzN2uZysgeDKpyTTzpOD1Ncf008VybA4Gu',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  String getOrderAmount() {
    if (isDiscountApplicable) {
      if (isDiscountInPercent) {
        return (totalPrice -
                (totalPrice * repDiscountModel!.data.discount / 100))
            .toStringAsFixed(2);
      } else {
        return (totalPrice - repDiscountModel!.data.discount)
            .toStringAsFixed(2);
      }
    } else {
      return totalPrice.toStringAsFixed(2);
    }
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

  void updateIsDiscountApplicable() {
    log("cartItemsCount in updateIsDiscountApplicable= $cartItemsCount");

    if (cartItemsCount >= 20) {
      isDiscountApplicable = true;
    } else {
      isDiscountApplicable = false;
    }
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

  String getPreviousBalancePrice() {
    num price = previousBalance - totalPrice;

    return price.toStringAsFixed(2);
  }

  customerGetDataHandler() async {
    log("customerGetDataHandler fired");
    // CustomLoader.showLoader(context: context);
    await CustomerGetService()
        .customerGetService(context: context, id: loginStorage.getUserId());
    // CustomLoader.hideLoader(context);
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
      customerId: loginStorage.getUserId(),
      dateTime: DateTime.now(),
      orderBy: 1,
      orderId: 0,
      orderProducts: model,
      discountType: isDiscountApplicable && isDiscountInPercent
          ? "By Percentage"
          : "By Value",
      discount: repDiscountModel != null && isDiscountApplicable
          ? repDiscountModel!.data.discount
          : 0,
      grandTotal: totalPrice,
      status: '',
      totalPrice: totalPrice,
      orderPaidAmount: totalPaid,
      orderPendingAmount: double.parse(getRemainigBalance()),
      remainingBalance: double.parse(getRemainigBalance()),
      totalBalance: double.parse(getTotalBalance()),
      previousBalance: previousBalance,
      netTotal: double.parse(getOrderAmount()),
    );

    final data = await pdfService.createInvoice(
      ctx: context,
      cartModel: cartModel,
      customerName: loginStorage.getUserFirstName() +
          " " +
          loginStorage.getUserLastName(),
      repName: loginStorage.getSalesRepName(),
      isOrderCompleted: false,
    );

    pdfService.savePdfFile("invoice_$number", data);
    number++;
  }

  Widget stripePaymentMethod() {
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
            } else {
              makePayment(amountCont.text.trim());
            }
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  Widget payPalPaymentMethod() {
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
            } else {
              // showToast("Do paypal here");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                      sandboxMode: true,
                      clientId:
                          "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                      secretKey:
                          "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                      returnURL: "https://samplesite.com/return",
                      cancelURL: "https://samplesite.com/cancel",
                      transactions: const [
                        {
                          "amount": {
                            "total": '10.12',
                            "currency": "USD",
                            "details": {
                              "subtotal": '10.12',
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          // "payment_options": {
                          //   "allowed_payment_method":
                          //       "INSTANT_FUNDING_SOURCE"
                          // },
                          "item_list": {
                            "items": [
                              {
                                "name": "A demo product",
                                "quantity": 1,
                                "price": '10.12',
                                "currency": "USD"
                              }
                            ],

                            // shipping address is not required though
                            "shipping_address": {
                              "recipient_name": "Jane Foster",
                              "line1": "Travis County",
                              "line2": "",
                              "city": "Austin",
                              "country_code": "US",
                              "postal_code": "73301",
                              "phone": "+00000000",
                              "state": "Texas"
                            },
                          }
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");
                      },
                      onError: (error) {
                        print("onError: $error");
                      },
                      onCancel: (params) {
                        print('cancelled: $params');
                      }),
                ),
              );
            }
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }
}
