import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';

class UpdateOrderBySalesrepService {
  Future<bool> updateOrderBySalesrep(
      {required BuildContext context, required int orderId}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        // "accept": "application/json",
      };

      // log("updateOrderBySalesrep body = $body");

      http.Response response = await http.put(
          Uri.parse('$apiBaseUrl/Order/UpdateOrderedStatus/$orderId'),
          // body: jsonEncode(body),
          headers: headers);

      Map jsonn = jsonDecode(response.body);

      log("json in updateOrderBySalesrep = $jsonn");

      if (response.statusCode == 200) {
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
