import 'package:flutter/widgets.dart';
import 'package:shop_app/models/customers_search_model.dart';

import '../models/resseller_customers_model.dart';

class CustomersSearchProvider extends ChangeNotifier {
  List<SalesrepCustomerData>? customerSearch = [];
  updateCustomer({List<SalesrepCustomerData>? newCustomer}) {
    customerSearch = newCustomer;
    notifyListeners();
  }
}
