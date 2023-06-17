import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';

class PaymentStripeAddService {
  Future paymentAddStripeService(
      {required BuildContext context,
      String? paymentTestKey,
      int? saleRepId}) async {
    try {
      Map body = {
        "publishableTestKey": paymentTestKey,
        "publishableLiveKey": "string",
        "testSecretKey": "string",
        "testLiveKey": "string",
        "clientId": "string",
        "saleRepId": saleRepId,
        "clientSecret": "string",
        "paymentMethodMobile": 0
      };

      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          url: '$apiBaseUrl/SaleRep/SalesRepPaymentGatewayAdd',
          body: body);

      if (res != null) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
