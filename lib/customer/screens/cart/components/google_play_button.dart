import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class GooglePlayButtonCard extends StatefulWidget {
  const GooglePlayButtonCard({Key? key}) : super(key: key);

  @override
  State<GooglePlayButtonCard> createState() => _GooglePlayButtonCardState();
}

class _GooglePlayButtonCardState extends State<GooglePlayButtonCard> {
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      width: 73,
      child: GooglePayButton(
        // paymentConfiguration: PaymentConfiguration.fromJsonString(
        //     'defaultApplePayConfigString'),
        paymentItems: _paymentItems,
        paymentConfigurationAsset: 'default_google_pay_config.json',
        width: 200,
        height: 60,
        type: GooglePayButtonType.plain,
        margin: const EdgeInsets.only(top: 10.0, bottom: 0, left: 4),
        onPaymentResult: (data) {
          print(data);
        },
        loadingIndicator: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
