import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/top_five_customers_model.dart';
import 'package:shop_app/models/top_five_product_model.dart';
import 'package:shop_app/providers/top_five_customers_provider.dart';
import 'package:shop_app/providers/top_five_products_provider.dart';

class TopFiveCustomersService {
  Future topFiveCustomerService({required BuildContext context}) async {
    List<TopFiveCustomersModel> model = [];

    try {
      http.Response response = await http.get(Uri.parse(
          'http://38.17.51.206:8070/api/Customer/GetTopFiveCustomers'));

      print('response--->${response.body}');
      print('response--->${response.statusCode}');

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
      print(err);
      return false;
    }
  }
}
