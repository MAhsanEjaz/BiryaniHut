import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/all_cities_model.dart';
import 'package:shop_app/providers/all_cities_provider.dart';

class GetAllCitiesService {
  Future getAllCitiesService(
      {required BuildContext context, required String cityCode}) async {
    List<AllCitiesModel>? model = [];

    try {
      http.Response response = await http
          .get(Uri.parse('$apiBaseUrl/States/GetCitiesByStateCode/$cityCode'));

      if (response.statusCode == 200) {
        var l = response.body;

        jsonDecode(l).forEach((element) {
          model.add(AllCitiesModel.fromJson(element));
        });

        Provider.of<AllCitiesProvider>(context, listen: false)
            .getAllCities(newCities: model);
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
