
import 'package:flutter/cupertino.dart';

import '../models/salesrep_orders_model.dart';

class SaleRepOrdersProvider extends ChangeNotifier{
  List<SaleRapOrdersList> ? repOrder=[];
  updateSaleRapOrder({ List<SaleRapOrdersList>? newRepOrders}){
    repOrder=newRepOrders;
    notifyListeners();
  }
}