import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/top_five_customers_model.dart';
import 'package:shop_app/providers/top_five_customers_provider.dart';
import 'package:shop_app/storages/login_storage.dart';

class TopFiveCustomersService {
  Future topFiveCustomerService({required BuildContext context}) async {
    List<TopFiveCustomersModel> model = [];
    LoginStorage storage = LoginStorage();

    log("storage.getUserId() = ${storage.getUserId()}");

    try {
      http.Response response = await http.get(Uri.parse(
          '$apiBaseUrl/Customer/GetTopFiveCustomers/${storage.getUserId()}'));

      log('response--->${response.body}');
      log('response--->${response.statusCode}');

      if (response.statusCode == 200) {
        var l = response.body;

        jsonDecode(l).forEach((element) {
          model.add(TopFiveCustomersModel.fromJson(element));
        });

        Provider.of<TopFiveCustomerProvider>(context, listen: false)
            .getFiveCustomers(newFiveCustomers: model);
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
