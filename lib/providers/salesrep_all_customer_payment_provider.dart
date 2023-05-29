
import 'package:flutter/material.dart';

import '../models/salesrep_all_customer_payment_model.dart';

class SalesrepAllCustomersPaymentsProvider extends ChangeNotifier{
  List<SalesRepAllCustomersList>? custList=[];
  updateList({List<SalesRepAllCustomersList>? newCustList}){
    custList=newCustList;
    notifyListeners();
  }
}