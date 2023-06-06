import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/top_five_customers_model.dart';

class TopFiveCustomerProvider extends ChangeNotifier {
  List<TopFiveCustomersModel>? fiveCustomers = [];

  getFiveCustomers({List<TopFiveCustomersModel>? newFiveCustomers}) {
    fiveCustomers = newFiveCustomers;
    notifyListeners();
  }
}
