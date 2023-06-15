import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';

class PutSaleRepDiscountService {
  Future putSaleRepDiscountService(
      {required BuildContext context,
      int? userId,
      String? discount,
      String? discountType}) async {
    var myDiscount = double.parse(discount!);

    try {
      var headers = {
        "Content-Type": "application/json",
      };
      Map body = {
        "id": userId,
        "discount": myDiscount,
        "discountType": discountType,
      };

      http.Response response = await http.put(
          Uri.parse('$apiBaseUrl/SaleRep/ÜpdateSaleRepDicount'),
          body: json.encode(body),
          headers: headers);

      print('url--->$apiBaseUrl/SaleRep/ÜpdateSaleRepDicount');

      print('response--->${response.body}');

      if (response.statusCode == 200) {
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
