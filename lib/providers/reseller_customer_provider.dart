import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/resseller_customers_model.dart';

class ResellerCustomerProvider extends ChangeNotifier {
  List<SalesrepCustomerData>? custList = [];
  updateCust({List<SalesrepCustomerData>? newCust}) {
    custList = newCust;
    notifyListeners();
  }
}
