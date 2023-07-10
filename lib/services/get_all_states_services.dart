import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/states_model.dart';
import 'package:shop_app/providers/states_provider.dart';

class GetAllStatesServices {
  Future getAllStatesServices(
      {required BuildContext context, String? cityName}) async {
    List<AllStatesModel>? model = [];

    try {
      http.Response response = await http
          .get(Uri.parse('$apiBaseUrl/States/GetStateByCity/$cityName'));
      print('url--->$apiBaseUrl/States/GetStateByCity/$cityName');
      print('response--->${response.body}');
      if (response.statusCode == 200) {
        var l = response.body;

        jsonDecode(l).forEach((element) {
          model.add(AllStatesModel.fromJson(element));
        });

        Provider.of<StatesProvider>(context, listen: false)
            .getAllStates(newStatesData: model);
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
