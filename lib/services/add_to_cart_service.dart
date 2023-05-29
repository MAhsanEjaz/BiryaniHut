import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class AddToCartService {
  Future<bool> addToCart(
      {required BuildContext context, required String cart}) async {
    log("cart string = $cart");
    try {
      const String addToCartUrl = "$apiBaseUrl/Order/AddToCart";
      var headers = {"Content-Type": "application/json"};
      http.Response response = await http.post(Uri.parse(addToCartUrl),
          body: cart, headers: headers);
      log("Response Status code ${response.statusCode}");
      log("addToCart response body = ${response.body}");
      Map json = jsonDecode(response.body);
      if (json["message"] == "Order Placed successfully!") {
        // log("Add To Cart Successfully");
        CustomSnackBar.showSnackBar(
            context: context, message: "Order Placed Successfully");
        return true;
      } else {
        // log("Unsuccessfull");
        CustomSnackBar.failedSnackBar(
            context: context, message: "Order could not be Placed");
        return false;
      }
    } catch (err) {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Something went wrong");

      return false;
    }
  }
}
