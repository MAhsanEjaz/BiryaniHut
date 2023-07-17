import 'package:flutter/material.dart';

import '../models/resseller_customers_model.dart';
import '../models/salesrep_orders_model.dart';

class AllOrdersProvider extends ChangeNotifier {
  List<SaleRapOrdersList>? allOrders = [];

  update({List<SaleRapOrdersList>? newOrders}) {
    allOrders = newOrders;
    notifyListeners();
  }

  clearList() {
    allOrders = [];
    notifyListeners();
  }
}
