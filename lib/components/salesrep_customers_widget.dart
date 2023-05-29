import 'dart:developer';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/reseller_order_time_calender_widget.dart';
import 'package:shop_app/customer/services/customer_delete_service.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/resseller_customers_model.dart';
import 'package:shop_app/sales%20rep/all_orders_screen.dart';
import 'package:shop_app/sales%20rep/salesrep_products_page.dart';
import 'package:shop_app/services/phone_format_service.dart';
import 'package:shop_app/services/update_custom_service.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:sumup/sumup.dart';
import '../constants.dart';
import '../customer/screens/cart/components/payment_card.dart';
import '../models/cart_model.dart';
import '../providers/account_balance_provider.dart';
import '../services/account_balance_service.dart';
import '../services/add_customer_balance_service.dart';
import '../size_config.dart';
import '../widgets/custom_textfield.dart';
import 'default_button.dart';

class SalesRepCustomersWidget extends StatefulWidget {
  SalesrepCustomerData customers;

  bool showDialogue;
  BuildContext context;

  SalesRepCustomersWidget(
      {Key? key,
      required this.customers,
      this.showDialogue = true,
      required this.context})
      : super(key: key);

  @override
  State<SalesRepCustomersWidget> createState() =>
      _SalesRepCustomersWidgetState();
}

class _SalesRepCustomersWidgetState extends State<SalesRepCustomersWidget> {
  int popupMenuValue = 1;

  LoginStorage loginStorage = LoginStorage();

  TextEditingController credCont = TextEditingController();

  int selectedPaymentIndex = 0;

  num totalPayable = 0;

  num totalPaid = 0;

  TextEditingController amountCont = TextEditingController();

  TextEditingController chequeNo = TextEditingController();

  TextEditingController cashAppTransId = TextEditingController();

  FocusNode amountNode = FocusNode();

  FocusNode chequeNoNode = FocusNode();

  FocusNode cashAppTransIdNode = FocusNode();

  List<String> paymentStringList = [];

  List<OrderPayment> paymentsList = [];

  // updateCreditLimitHandler() async {
  //   CustomLoader.showLoader(context: widget.context);
  //   await UpdateCreditLimitService().updateLimit(
  //       context: widget.context,
  //       custId: widget.customers.id ?? 0,
  //       creditAmount: credCont.text);
  //   CustomLoader.hideLoader(widget.context);
  // }

  getCustomerAccountBalance({required int customerId}) async {
    CustomLoader.showLoader(context: widget.context);
    await AccountBalanceService()
        .accountBalanceService(context: widget.context, id: customerId);
    CustomLoader.hideLoader(widget.context);
  }

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController solonName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  updateCustomerHandler() async {
    CustomLoader.showLoader(context: context);

    bool res = await UpdateCustomService().updateCustomerService(
        context: context,
        address: address.text,
        customerId: widget.customers.id,
        firstName: firstName.text,
        lastName: lastName.text,
        phone: phone.text);

    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Update Successfully'),
        backgroundColor: Colors.green[600],
      ));
      widget.customers.address = address.text;
      widget.customers.firstName = firstName.text;
      widget.customers.lastName = lastName.text;
      widget.customers.phone = phone.text;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong'),
        backgroundColor: Colors.red,
      ));
    }

    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    super.initState();

    firstName.text = widget.customers.firstName!;
    lastName.text = widget.customers.lastName!;
    solonName.text = widget.customers.salonName!;
    phone.text = widget.customers.phone!;
    address.text = widget.customers.address!;
  }

  deleteCustomerHandler(BuildContext context, int? id, int? selId) async {
    CustomLoader.showLoader(context: context);
    bool res = await CustomerDeleteService()
        .customerDeleteService(context: context, custId: id!, selId: selId!);
    CustomLoader.hideLoader(context);
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.pink,
          content:
              Text('Request to delete customer send to admin for approval')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Customer Id:"+ " " +"112")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Customer Id:" " ",
                        style: custStyle,
                        children: [
                      TextSpan(text: "${widget.customers.id}", style: idStyle)
                    ])),
                PopupMenuButton<int>(
                  // onSelected: (value) {
                  //
                  // },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: popupMenuValue + 1,
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalesRepProductsPage(
                                      isReseller: true,
                                      //! using false here to show cart option with all products
                                      //! if sales rep wants to order for any of its customer.
                                      customerName:
                                          widget.customers.firstName! +
                                              " " +
                                              widget.customers.lastName!,
                                      customerId: widget.customers.id!,
                                    ),
                                  ));
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.shopping_basket),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Make Order"),
                              ],
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllOrdersScreen(
                                            customerId:
                                                widget.customers.id ?? 0,
                                          )));
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.shopping_cart_checkout),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("All Orders"),
                              ],
                            ),
                          ),
                          const Divider(),

                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);

                              await getCustomerAccountBalance(
                                  customerId: widget.customers.id!);

                              showAddPaymentDialog(context);
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.monetization_on),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Pay Previous Balance"),
                              ],
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) => BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaY: 10, sigmaX: 10),
                                        child: AlertDialog(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          icon: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Card(
                                                      elevation: 5.0,
                                                      child:
                                                          Icon(Icons.close)))),
                                          actions: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await updateCustomerHandler();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Update'),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: appColor),
                                              ),
                                            )
                                          ],
                                          title: const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Update Profile',
                                                style: TextStyle(
                                                    color: appColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Divider(),
                                                CustomTextField(
                                                  prefixWidget:
                                                      const Icon(Icons.person),
                                                  controller: firstName,
                                                  hint: 'First Name',
                                                ),
                                                CustomTextField(
                                                    prefixWidget: const Icon(
                                                        Icons.person),
                                                    controller: lastName,
                                                    hint: 'Last Name'),
                                                CustomTextField(
                                                    prefixWidget: const Icon(
                                                        Icons.home_work_sharp),
                                                    controller: solonName,
                                                    hint: 'Salon Name'),
                                                CustomTextField(
                                                    inputFormats: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          12),
                                                      PhoneInputFormatter(),
                                                    ],
                                                    inputType:
                                                        TextInputType.number,
                                                    prefixWidget:
                                                        const Icon(Icons.phone),
                                                    controller: phone,
                                                    hint: 'Phone'),
                                                CustomTextField(
                                                    prefixWidget:
                                                        const Icon(Icons.home),
                                                    controller: address,
                                                    hint: 'Address'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.update),
                                SizedBox(width: 10),
                                Text('Update Profile')
                              ],
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);

                              showAwesomeAlert(
                                  context: context,
                                  msg: 'Do you want to delete this customer',
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  okBtnText: "Delete",
                                  cancelBtnText: 'Cancel',
                                  onOkPress: () {
                                    deleteCustomerHandler(
                                        context,
                                        widget.customers.id,
                                        loginStorage.getUserId());

                                    log('cust---->${widget.customers.id}');
                                    log('sale---->${loginStorage.getUserId()}');
                                  },
                                  onCancelPress: () {});
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 10),
                                Text("Delete Customer")
                              ],
                            ),
                          )

                          // InkWell(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //     updateCreditLimitDialog(context);
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.credit_score),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Text("Update Credit Limit"),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                  elevation: 2,
                )
              ],
            ),
            const Divider(
              thickness: 1.2,
            ),
            ListTile(
              leading: CircleAvatar(
                maxRadius: 25.0,
                backgroundImage: widget.customers.customerImagePath == "" ||
                        widget.customers.customerImagePath == null
                    ? NetworkImage(userDummyUrl)
                    : NetworkImage(widget.customers.customerImagePath!),
              ),
              title: ResellerOrderTimeDateWidget(
                  icon: Icons.home_filled,
                  text: "${widget.customers.salonName}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResellerOrderTimeDateWidget(
                      icon: Icons.person,
                      text: widget.customers.firstName! +
                          " " +
                          widget.customers.lastName!),
                  ResellerOrderTimeDateWidget(
                      icon: Icons.call, text: "${widget.customers.phone}")
                ],
              ),
              // trailing:,
            ),
            const Divider(
              thickness: 1,
            ),
            ResellerOrderTimeDateWidget(
                icon: Icons.location_on_outlined,
                text: "${widget.customers.address}")
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     ResellerOrderTimeDateWidget(
            //         icon: Icons.calendar_month, text: "Apr,10,2022"),
            //     ResellerOrderTimeDateWidget(
            //         icon: Icons.location_on_outlined,
            //         text: "${customers.address}")
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  showAddPaymentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setStatess) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 12.0),
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close)),
                        ),
                        Consumer<AccountBalanceProvider>(
                            builder: (context, data, _) {
                          if (data.accountBalanceModel!.data!.accountBalance !=
                              null) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "Previous Balance : \$ ${data.accountBalanceModel!.data!.accountBalance!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              PaymentCard(
                                boxHeight: 45,
                                boxWidth: 45,
                                image: getSumupImageUrl(),
                                color: selectedPaymentIndex == 1 ? true : false,
                                onTap: () {
                                  selectedPaymentIndex = 1;

                                  handleSumupClick(setStatess);
                                  setStatess(() {});
                                },
                                paymentName: 'SumUp',
                              ),
                              //! payment by cash
                              PaymentCard(
                                boxHeight: 45,
                                boxWidth: 45,
                                image:
                                    'https://st.depositphotos.com/1477399/1844/i/600/depositphotos_18442353-stock-photo-human-hands-exchanging-money.jpg',
                                color: selectedPaymentIndex == 2 ? true : false,
                                onTap: () {
                                  selectedPaymentIndex = 2;
                                  setStatess(() {});
                                },
                                paymentName: 'Cash',
                              ),

                              //! payment with cheque
                              PaymentCard(
                                boxHeight: 45,
                                boxWidth: 45,
                                image:
                                    'https://img.freepik.com/premium-vector/man-holds-bank-check-with-signature-businessman-with-cheque-book-hand-payments-financial-operations_458444-434.jpg?w=360',
                                color: selectedPaymentIndex == 3 ? true : false,
                                onTap: () {
                                  selectedPaymentIndex = 3;
                                  setStatess(() {});
                                },
                                paymentName: 'Cheque',
                              ),

                              //! payment with cash app
                              PaymentCard(
                                boxHeight: 45,
                                boxWidth: 45,
                                image:
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Square_Cash_app_logo.svg/1200px-Square_Cash_app_logo.svg.png',
                                color: selectedPaymentIndex == 4 ? true : false,
                                onTap: () {
                                  selectedPaymentIndex = 4;
                                  setStatess(() {});
                                },
                                paymentName: 'Cash App',
                              ),
                            ],
                          ),
                        ),
                        //! cash on delivery
                        if (selectedPaymentIndex == 2)
                          cashPaymentDesign(setStatess),

                        //! cheque payment
                        if (selectedPaymentIndex == 3)
                          chequePaymentDesign(setStatess),

                        //! cashapp payment payment

                        if (selectedPaymentIndex == 4)
                          cashAppPaymentDesign(setStatess),
                        const SizedBox(
                          height: 10,
                        ),

                        if (paymentStringList.isNotEmpty)
                          ListView.builder(
                            itemCount: paymentStringList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, bottom: 4),
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

                        const SizedBox(
                          height: 10,
                        ),
                        DefaultButton(
                          text: "Pay",
                          press: () {
                            if (totalPaid == 0) {
                              showToast("Please pay some amount first");
                              return;
                            }

                            Navigator.of(context).pop();

                            Map body = {
                              "payments": paymentsList,
                              "customerId": widget.customers.id,
                              "totalAmount": -totalPaid
                            };

                            //! -ve sign with paid amount
                            //! because -ve sign shows amount for customer

                            log("body in addCustomerBalance = $body");
                            paymentsList.clear();
                            paymentStringList.clear();
                            totalPaid = 0;

                            addCustomerBalance(body);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  String getSumupImageUrl() {
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0FdJM8umSkq0hq-KyV6RYxl1LG7LWmMAdfg&usqp=CAU';
  }

  Future<void> handleSumupClick(setStatess) async {
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
    setStatess(() {});
  }

  Widget chequePaymentDesign(setStatess) {
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
                  context: widget.context, msg: "Cheque No can't be empty");
              return;
            } else if (amountCont.text.trim().isEmpty) {
              amountNode.requestFocus();
              showAwesomeAlert(
                  context: widget.context, msg: "Please Enter amount first");
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
            FocusScope.of(widget.context).unfocus();
            setStatess(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  cashAppPaymentDesign(setStatess) {
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
                  context: widget.context, msg: "Please Enter amount first");
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
            FocusScope.of(widget.context).unfocus();
            setStatess(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  Widget cashPaymentDesign(setStatess) {
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
                  context: widget.context, msg: "Please Enter amount first");
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
            FocusScope.of(widget.context).unfocus();
            setStatess(() {});
          },
          text: "Save",
          width: getProportionateScreenWidth(100),
        )
      ],
    );
  }

  // updateCreditLimitDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12.0)),
  //           alignment: Alignment.center,
  //           child: SingleChildScrollView(
  //             physics: const AlwaysScrollableScrollPhysics(),
  //             child: Card(
  //               margin: const EdgeInsets.symmetric(
  //                   horizontal: 10.0, vertical: 12.0),
  //               elevation: 10.0,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12.0)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text("Enter Amount"),
  //                   CustomTextField(
  //                     controller: credCont,
  //                     inputType: TextInputType.number,
  //                     // hint: "",
  //                     isEnabled: true,
  //                   ),
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                   DefaultButton(
  //                     text: "Update Limit",
  //                     press: () {
  //                       Navigator.of(context).pop();
  //                       updateCreditLimitHandler();
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future<void> addCustomerBalance(body) async {
    bool isBalanceAdded = false;
    CustomLoader.showLoader(context: widget.context);
    isBalanceAdded = await AddCustomerBalanceService()
        .addCustomerBalace(context: widget.context, body: body);
    CustomLoader.hideLoader(widget.context);

    if (isBalanceAdded) {
      CustomSnackBar.showSnackBar(
          context: widget.context, message: "Balance Added Successfully");
    } else {
      CustomSnackBar.failedSnackBar(
          context: widget.context, message: "Balance Could not be Added");
    }
  }
}

class SalesRapCustomerSearchWidget extends StatelessWidget {
  SalesrepCustomerData customerSearchData;

  SalesRapCustomerSearchWidget({Key? key, required this.customerSearchData})
      : super(key: key);
  int popupMenuValue = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Customer Id:"+ " " +"112")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Customer Id:" " ",
                        style: custStyle,
                        children: [
                      TextSpan(text: "${customerSearchData.id}", style: idStyle)
                    ])),
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesRepProductsPage(
                              isReseller: false,
                              //! using false here to show cart option with all products
                              //! if sales rep wants to order for any of its customer.
                              customerName: customerSearchData.firstName! +
                                  " " +
                                  customerSearchData.lastName!,
                              customerId: customerSearchData.id!,
                            ),
                          ));
                    } else {
                      log("nothing to do here");
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: popupMenuValue,
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(Icons.shopping_basket),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Make Order"),
                        ],
                      ),
                    ),
                  ],
                  elevation: 2,
                ),
              ],
            ),
            const Divider(
              thickness: 1.2,
            ),
            ListTile(
              leading: CircleAvatar(
                  maxRadius: 25.0,
                  backgroundImage: NetworkImage(dummyImageUrl)),
              title: Text("${customerSearchData.firstName}"),
              subtitle: Text("${customerSearchData.lastName}"),
              trailing: Text("${customerSearchData.salonName}"),
            ),
            const Divider(
              thickness: 1.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ResellerOrderTimeDateWidget(
                    icon: Icons.calendar_month, text: "Apr,10,2022"),
                ResellerOrderTimeDateWidget(
                    icon: Icons.location_on_outlined,
                    text: "${customerSearchData.address}")
              ],
            )
          ],
        ),
      ),
    );
  }
}
