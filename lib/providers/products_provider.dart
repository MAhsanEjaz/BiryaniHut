import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/products_model.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductData>? prod = [];
  FocusNode productSearchNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  updateProd({List<ProductData>? newProd}) {
    prod = newProd;
    notifyListeners();
  }

  clearProductsSearchCont() {
    productSearchNode.unfocus();
    searchCont.clear();
    notifyListeners();
  }
}
