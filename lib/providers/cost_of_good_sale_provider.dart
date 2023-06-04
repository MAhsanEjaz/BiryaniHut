import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cost_of_good_sale_model.dart';

class CostOfGooddSaleProvider extends ChangeNotifier {
  List<GoodSaleModel>? saleProvider = [];

  getGoodSales({List<GoodSaleModel>? newSaleProvider}) {
    saleProvider = newSaleProvider;
    notifyListeners();
  }
}
