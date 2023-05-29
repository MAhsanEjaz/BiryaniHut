import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/common_model.dart';

class AddCustomerOrderReviewService {
  Future<bool> addCustomerOrderReview(
      {required BuildContext context, required var body}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
      };

      log("addCustomerOrderReview body = $body");

      http.Response response = await http.post(
          Uri.parse('$apiBaseUrl/Order/CustomerOrderReview'),
          body: jsonEncode(body),
          headers: headers);

      Map<String, dynamic> jsonn = jsonDecode(response.body);

      log("json in addCustomerOrderReview = $jsonn");

      CommonRespnceModel model = CommonRespnceModel.fromJson(jsonn);

      if (model.message == "Review added successfully!") {
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
