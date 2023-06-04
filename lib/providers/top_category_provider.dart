import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/top_category_model.dart';

class TopCategoryProvider extends ChangeNotifier {
  List<TopCategoryModel>? model = [];

  getCategories({List<TopCategoryModel>? newModel}) {
    model = newModel;
    notifyListeners();
  }
}
