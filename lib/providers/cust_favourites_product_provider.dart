import 'package:flutter/cupertino.dart';

import '../models/products_model.dart';

class CustFavouritesProductsProvider extends ChangeNotifier {
  List<ProductData>? favProd = [];

  updateFav({List<ProductData>? newFavProd}) {
    favProd = newFavProd;
    notifyListeners();
  }

  deleteData(int index) {
    favProd!.removeAt(index);
    notifyListeners();
  }
}
