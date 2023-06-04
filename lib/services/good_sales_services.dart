import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/cost_of_good_sale_model.dart';
import 'package:shop_app/providers/cost_of_good_sale_provider.dart';
import 'package:shop_app/services/customer_get_profile_service.dart';

class CostOfGoodSalesService {
  Future goodSalesServices({required BuildContext context}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: 'http://38.17.51.206:8070/api/Reports/getCostOfGoodsSold');

      if (res != null) {
        CostOfGoodSaleModel costOfGoodSaleModel =
            CostOfGoodSaleModel.fromJson(res);
        Provider.of<CostOfGooddSaleProvider>(context, listen: false)
            .getGoodSales(newSaleProvider: costOfGoodSaleModel.data);
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
