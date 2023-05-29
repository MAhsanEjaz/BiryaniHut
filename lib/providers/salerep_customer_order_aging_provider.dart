
import 'package:flutter/material.dart';

import '../models/salrrep_customer_order_aging_model.dart';

class SaleRepCustomOrderAgingProvider extends ChangeNotifier{
  CustomerOrderAgingList? orderAging;
  updateCustomeAging({ CustomerOrderAgingList? newOrderAging}){
    orderAging=newOrderAging;
    notifyListeners();
  }
}