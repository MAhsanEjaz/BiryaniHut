import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

const String updateCreditUrl = apiBaseUrl + "/Customer/UpdateCustomerSaleRep?";

class UpdateCreditLimitService {
  Future updateLimit(
      {required BuildContext context,
      required int custId,
      required String creditAmount}) async {
    try {
      http.Response response = await http.put(
          Uri.parse(updateCreditUrl + "cId=$custId&creditLimit=$creditAmount"));
      if (response.statusCode == 200) {
        print("Updated Successfully");
        CustomSnackBar.showSnackBar(
            context: context, message: "Updated Successfully");
        return true;
      } else {
        print("UnSuccessful");
        CustomSnackBar.failedSnackBar(
            context: context, message: "UnSuccessful");
        return false;
      }
    } catch (err) {
      print("Exception in Update Credit Limit Service $err");
      return null;
    }
  }
}
