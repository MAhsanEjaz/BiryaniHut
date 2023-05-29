import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';

class UpdateCustmerBalanceService {
  Future updateCustomerBalance({
    required BuildContext context,
    int? customerId,
    num? accountBalance,
    // String? creditLimit
  }) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        // "accept": "application/json",
      };

      Map body = {
        "customerId": customerId,
        "accountBalance": accountBalance,
        // "creditLimit": creditLimit
      };

      log("updateCustomerBalance body = $body");

      http.Response response = await http.put(
          Uri.parse('$apiBaseUrl/Customer/UpdateCustomerBalance'),
          body: json.encode(body),
          headers: headers);

      Map jsonn = jsonDecode(response.body);

      log("json in updateCustomerBalance = $jsonn");

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
