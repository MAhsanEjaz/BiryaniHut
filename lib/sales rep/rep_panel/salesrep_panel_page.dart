import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';

class SalesrepPanelPage extends StatefulWidget {
  const SalesrepPanelPage({Key? key}) : super(key: key);

  @override
  State<SalesrepPanelPage> createState() => _SalesrepPanelPageState();
}

class _SalesrepPanelPageState extends State<SalesrepPanelPage> {
  bool isStripeEnabled = false;
  bool isPayPalEnabled = false;
  bool isApplePayEnabled = false;
  bool isGoogleEnabled = false;
  LoginStorage loginStorage = LoginStorage();

  final Key key = UniqueKey();

  final stripeController = TextEditingController();

  String? apiKey;

  apiKeyGet() async {
    apiKey = await CustomDb().getKey();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    apiKeyGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColor,
          title: const Text(
            "Payment Setup Panel",
          )),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Stripe Key: $apiKey"),
          ),
          CheckboxListTile(
            title: const Text("Stripe"),
            value: isStripeEnabled,
            onChanged: (value) {
              isStripeEnabled = value!;
              isPayPalEnabled = false;
              isApplePayEnabled = false;
              isGoogleEnabled = false;
              setState(() {});
            },
          ),
          const Divider(),
          isStripeEnabled
              ? CustomPaymentCard(
                  controller: stripeController,
                  onTap: () async {
                    myPublishKey = stripeController.text;

                    await CustomDb().saveKey(key: myPublishKey);

                    // loginStorage.setStripeKey(stripeKey: myPublishKey!);
                    restartApp(context);
                    log("myPublishKey = $myPublishKey");
                    setState(() {});
                  },
                )
              : const SizedBox(),
          CheckboxListTile(
            title: const Text("Paypal"),
            value: isPayPalEnabled,
            onChanged: (value) {
              isPayPalEnabled = value!;
              isStripeEnabled = false;
              isApplePayEnabled = false;
              isGoogleEnabled = false;
              setState(() {});
            },
          ),
          const Divider(),
          isPayPalEnabled
              ? CustomPaymentCard(
                  onTap: () {},
                )
              : const SizedBox(),
          CheckboxListTile(
            title: const Text("Apple Pay"),
            value: isApplePayEnabled,
            onChanged: (value) {
              isApplePayEnabled = value!;
              isPayPalEnabled = false;
              isStripeEnabled = false;
              isGoogleEnabled = false;
              setState(() {});
            },
          ),
          const Divider(),
          isApplePayEnabled
              ? CustomPaymentCard(
                  onTap: () {},
                )
              : const SizedBox(),
          CheckboxListTile(
            title: const Text("Google Pay"),
            value: isGoogleEnabled,
            onChanged: (value) {
              isGoogleEnabled = value!;
              isPayPalEnabled = false;
              isStripeEnabled = false;
              isApplePayEnabled = false;
              setState(() {});
            },
          ),
          isGoogleEnabled
              ? CustomPaymentCard(
                  onTap: () {},
                )
              : const SizedBox(),
        ],
      )),
    );
  }

  restartApp(BuildContext context) async {
    CustomLoader.showLoader(context: context);

    await Future.delayed(Duration(seconds: 2));
    CustomLoader.hideLoader(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MyApp()),
      (route) => false,
    );
  }
}

class CustomPaymentCard extends StatefulWidget {
  TextEditingController? controller;
  Function()? onTap;

  CustomPaymentCard({this.controller, this.onTap});

  @override
  State<CustomPaymentCard> createState() => _CustomPaymentCardState();
}

class _CustomPaymentCardState extends State<CustomPaymentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: appColor)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                // minlines: 4,
                hint: 'Enter payment key',
                controller: widget.controller,
              ),
              ElevatedButton(
                onPressed: (widget.onTap),
                child: const Text("Save"),
                style: ElevatedButton.styleFrom(primary: appColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDb {
  Future saveKey({String? key}) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('key', key!);
  }

  Future getKey({String? key}) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.get('key');
  }
}
