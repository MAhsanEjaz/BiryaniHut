import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/categoriies_model.dart';

class NewCategoriesProvider extends ChangeNotifier {
  List<CategoriesData>? model = [];

  getCategories({List<CategoriesData>? newModel}) {
    model = newModel;
    notifyListeners();
  }
}
