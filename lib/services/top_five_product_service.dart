import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/top_five_product_model.dart';
import 'package:shop_app/providers/top_five_products_provider.dart';
import 'package:shop_app/storages/login_storage.dart';

class TopFiveProductsService {
  Future topFIveProductsService({required BuildContext context}) async {
    try {
      List<TopFiveProductsModel> model = [];

      LoginStorage storage = LoginStorage();

      log("url = ${'$apiBaseUrl/Product/GetTopRatedProductsBySalesRep?saleRepId=${storage.getUserId()}'}");
      http.Response response = await http.get(Uri.parse(
          '$apiBaseUrl/Product/GetTopRatedProductsBySalesRep?saleRepId=${storage.getUserId()}'));

      print('response--->${response.body}');
      print('response--->${response.statusCode}');

      if (response.statusCode == 200) {
        var l = response.body;
        jsonDecode(l).forEach((element) {
          model.add(TopFiveProductsModel.fromJson(element));
        });

        Provider.of<TopFiveProductProvider>(context, listen: false)
            .getTopProducts(newTopProducts: model);
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
