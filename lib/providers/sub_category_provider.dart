import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/products_model.dart';


class SubCategoryProvider extends ChangeNotifier {
  List<ProductData>? model = [];

  getSubCategory({List<ProductData>? newModel}) {
    model = newModel;
    notifyListeners();
  }
}
