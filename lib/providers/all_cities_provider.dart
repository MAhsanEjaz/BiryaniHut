import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/all_cities_model.dart';

class AllCitiesProvider extends ChangeNotifier {
  List<AllCitiesModel>? cities = [];

  getAllCities({List<AllCitiesModel>? newCities}) {
    cities = newCities;
    notifyListeners();
  }
}
