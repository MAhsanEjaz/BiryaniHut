import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/top_category_model.dart';
import 'package:shop_app/providers/top_category_provider.dart';
import 'package:http/http.dart' as http;

class TopCatService {
  Future topCatService({required BuildContext context}) async {
    List<TopCategoryModel> model = [];

    try {
      http.Response response = await http.get(
          Uri.parse('http://38.17.51.206:8070/api/Reports/getCategorySales'));

      print('response---->${response.body}');
      print('response---->${response.statusCode}');

      if (response.statusCode == 200) {
        var l = response.body;

        // var responseJson = jsonDecode(l);

        if (jsonDecode(l) is List<dynamic>) {
          jsonDecode(l).forEach((element) {
            model.add(TopCategoryModel.fromJson(element));
          });
        } else if (jsonDecode(l) is Map<String, dynamic>) {
          model.add(TopCategoryModel.fromJson(jsonDecode(l)));
        }

        Provider.of<TopCategoryProvider>(context, listen: false)
            .getCategories(newModel: model);
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
