import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/payment_key_get_model.dart';
import 'package:shop_app/providers/payment_get_provider.dart';

class GetPaymentKeyService {
  List<PaymentKeyGetModel> model = [];

  Future getPaymentKeyService(
      {required BuildContext context, int? salRepId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url:
              '$apiBaseUrl/SaleRep/SalesRepPaymentGatewayGet?SaleRepId=$salRepId');

      if (res != null) {
        PaymentKeyGetModel paymentKeyGetModel =
            PaymentKeyGetModel.fromJson(res);

        Provider.of<PaymentGetProvider>(context, listen: false)
            .getPaymentData(newModel: paymentKeyGetModel);
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
