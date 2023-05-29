import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/products_model.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductData>? prod = [];

  updateProd({List<ProductData>? newProd}) {
    prod = newProd;
    notifyListeners();
  }
}
