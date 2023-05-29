import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class AppleButtonCard extends StatefulWidget {
  const AppleButtonCard({Key? key}) : super(key: key);

  @override
  State<AppleButtonCard> createState() => _AppleButtonCardState();
}

class _AppleButtonCardState extends State<AppleButtonCard> {
  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ApplePayButton(
        paymentConfigurationAsset: 'payment_profile_apple_pay.json',
        paymentItems: _paymentItems,
        width: 200,
        height: 50,
        type: ApplePayButtonType.plain,
        margin: const EdgeInsets.only(top: 15.0),
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
