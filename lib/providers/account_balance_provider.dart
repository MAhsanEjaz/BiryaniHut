import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/account_balance_model.dart';

class AccountBalanceProvider extends ChangeNotifier {
  AccountBalanceModel? accountBalanceModel;

  getAccountData({AccountBalanceModel? newAccountBalanceModel}) {
    accountBalanceModel = newAccountBalanceModel;
    notifyListeners();
  }
}
