import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/top_five_product_model.dart';

class TopFiveProductProvider extends ChangeNotifier {
  List<TopFiveProductsModel>? topProducts = [];

  getTopProducts({List<TopFiveProductsModel>? newTopProducts}) {
    topProducts = newTopProducts;
    notifyListeners();
  }
}
