import 'package:flutter/material.dart';


import '../models/products_model.dart';

class ProductSearchProvider extends ChangeNotifier {
  List<ProductData>? prodSearch = [];
  updateSearch({List<ProductData>? newSearch}) {
    prodSearch = newSearch;
    notifyListeners();
  }
}
