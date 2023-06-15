import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/common_model.dart';

class AddCustomerBalanceService {
  Future<bool> addCustomerBalace(
      {required BuildContext context, required Map body}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        // "accept": "application/json",
      };

      log("AddCustomerBalance body = $body");

      http.Response response = await http.put(
          Uri.parse('$apiBaseUrl/Customer/AddCustomerBalance'),
          body: jsonEncode(body),
          headers: headers);

      Map<String, dynamic> jsonn = jsonDecode(response.body);

      log("json responce in addCustomerBalace = $jsonn");

      CommonRespnceModel model = CommonRespnceModel.fromJson(jsonn);

      if (model.message == "Account Balance Updated Successfully") {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      log(err.toString());
      return false;
    }
  }
}
