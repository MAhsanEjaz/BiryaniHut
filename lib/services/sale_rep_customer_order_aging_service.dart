import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/salrrep_customer_order_aging_model.dart';
import 'package:shop_app/providers/salerep_customer_order_aging_provider.dart';

const String custOrderAgingUrl = apiBaseUrl + "/Order/";

class SaleRepCustomerOrderAgingService {
  Future getCustomerOrderAging(
      {required BuildContext context, required int salerepId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: custOrderAgingUrl + "SaleRepCustomerOrdersAging/$salerepId");
      if (res != null) {
        SaleRepCustomerOrderAgingModel orderAgingModel =
            SaleRepCustomerOrderAgingModel.fromJson(res);
        Provider.of<SaleRepCustomOrderAgingProvider>(context, listen: false)
            .updateCustomeAging(newOrderAging: orderAgingModel.data);
        return true;
      }
    } catch (err) {
      print("Exception in salerep customer order aging service $err");
      return null;
    }
  }
}
