
import 'package:flutter/widgets.dart';

import '../models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier{
  List<CategoriesList> ?catList=[];
  updateCat({List<CategoriesList>? newCat}){
    catList=newCat;
    notifyListeners();
  }
}