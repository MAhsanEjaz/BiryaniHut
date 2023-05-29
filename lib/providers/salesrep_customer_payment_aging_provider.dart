
import 'package:flutter/foundation.dart';

import '../models/sales_rep_customer_payment_aging_model.dart';

class SalesRepCustomerPaymentAgingProvider extends ChangeNotifier{
  List<CustomerPaymentAgingList>? paymentsAging=[];
  updateList({  List<CustomerPaymentAgingList>? newAging}){
    paymentsAging=newAging;
    notifyListeners();
  }
}