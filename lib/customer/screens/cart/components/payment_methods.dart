import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/customer/screens/cart/components/apple_button.dart';
import 'package:shop_app/customer/screens/cart/components/google_play_button.dart';
import 'package:sumup/sumup.dart';
import 'payment_card.dart';

class PaymentMethods extends StatefulWidget {
  int? selectedIndex;
  var amount;

  PaymentMethods({this.selectedIndex, this.amount});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Select Payment Mode",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 3.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PaymentCard(
                  image:
                      'https://img.freepik.com/premium-vector/cash-delivery_569841-162.jpg?w=2000',
                  color: widget.selectedIndex == 1 ? true : false,
                  onTap: () {
                    widget.selectedIndex = 1;
                    setState(() {});
                  },
                  paymentName: 'Cash',
                ),
                PaymentCard(
                  image:
                      'http://assets.stickpng.com/thumbs/62a382de6209494ec2b17086.png',
                  color: widget.selectedIndex == 2 ? true : false,
                  onTap: () {
                    makePayment(widget.amount == null
                        ? "22"
                        : widget.amount.toString());
                    widget.selectedIndex = 2;
                    setState(() {});
                  },
                  paymentName: 'Stripe',
                ),
                PaymentCard(
                  image:
                      'https://cdn.pixabay.com/photo/2018/05/08/21/29/paypal-3384015_1280.png',
                  color: widget.selectedIndex == 3 ? true : false,
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => UsePaypal(
                                sandboxMode: true,
                                clientId:
                                    "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                                secretKey:
                                    "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                                returnURL: "https://samplesite.com/return",
                                cancelURL: "https://samplesite.com/cancel",
                                transactions: [
                                  {
                                    "amount": {
                                      "total": widget.amount,
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": widget.amount,
                                        "shipping": '0',
                                        "shipping_discount": 0
                                      }
                                    },
                                    "description":
                                        "The payment transaction description.",
                                    // "payment_options": {
                                    //   "allowed_payment_method":
                                    //       "INSTANT_FUNDING_SOURCE"
                                    // },
                                    "item_list": {
                                      "items": [
                                        {
                                          "name": "Influance product",
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
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  log("onSuccess: $params");
                                },
                                onError: (error) {
                                  log("onError: $error");
                                },
                                onCancel: (params) {
                                  log('cancelled: $params');
                                })));

                    widget.selectedIndex = 3;
                    setState(() {});
                  },
                  paymentName: 'Paypal',
                ),
                // if (Platform.isIOS) const AppleButtonCard(),
                // if (Platform.isAndroid) const GooglePlayButtonCard(),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(String amount) async {
    try {
      paymentIntentData = await createPaymentIntent(
          amount, 'USD'); //json.decode(response.body);
      // log('Response body==>${response.body.toString()}');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.system,
                  // appearance: PaymentSheetAppearance(
                  //     colors: PaymentSheetAppearanceColors(
                  //         primary: Colors.black,
                  //         background: Colors.orange[100])),
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      log('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        log('payment intent' + paymentIntentData!['id'].toString());
        log('payment intent' + paymentIntentData!['client_secret'].toString());
        log('payment intent' + paymentIntentData!['amount'].toString());
        log('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Payment Successful")));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        log('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      log('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      log('$e');
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
      log('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
