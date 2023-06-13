import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/salesrep_get_discount_model.dart';

class SalesrepDiscountProvider extends ChangeNotifier {
  SalesrepDiscountModel? repDiscountModel;
  void updateRepDiscount({required SalesrepDiscountModel model}) {
    repDiscountModel = model;
    notifyListeners();
  }
}
