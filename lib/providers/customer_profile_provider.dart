import 'package:flutter/material.dart';
import 'package:shop_app/models/customer_profile_model.dart';

class CustomerProfileProvider extends ChangeNotifier {
  CustomerProfileModel? customerProfileModel;

  getProfileData({CustomerProfileModel? newcCustomerProfileModel}) {
    customerProfileModel = newcCustomerProfileModel;
    notifyListeners();
  }

  clearData() {
    customerProfileModel = null;
    notifyListeners();
  }
}
