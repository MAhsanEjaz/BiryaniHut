import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/account_balance_model.dart';
import 'package:shop_app/providers/account_balance_provider.dart';

class AccountBalanceService {
  Future accountBalanceService({required BuildContext context, int? id}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: '$apiBaseUrl/Customer/GetAccountBalance/$id');

      if (res != null) {
        AccountBalanceModel accountBalanceModel =
            AccountBalanceModel.fromJson(res);
        Provider.of<AccountBalanceProvider>(context, listen: false)
            .getAccountData(newAccountBalanceModel: accountBalanceModel);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
