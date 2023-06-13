import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/salesrep_get_discount_model.dart';
import 'package:shop_app/providers/salesrep_discount_provider.dart';
import '../storages/login_storage.dart';

class SalesrepGetDiscountService {
  LoginStorage storage = LoginStorage();

  Future getRepDiscount({required BuildContext context}) async {
    try {
      String apiUrl =
          "$apiBaseUrl/SaleRep/GetSaleRepDicount?SaleRepId=${storage.getUserId()}";

      log("SalesrepGetDiscountService api = $apiUrl");
      var res = await CustomGetRequestService().httpGetRequest(
        context: context,
        url: apiUrl,
      );

      log("SalesrepGetDiscountService responce = $res");

      if (res["data"] != null) {
        SalesrepDiscountModel model = SalesrepDiscountModel.fromJson(res);

        Provider.of<SalesrepDiscountProvider>(context, listen: false)
            .updateRepDiscount(model: model);

        return true;
      } else {
        return false;
      }
    } catch (err) {
      log(err.toString());
      return false;
    }
  }
}
