import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/providers/all_orders_provider.dart';
import '../models/salesrep_orders_model.dart';

const String getAllCustUrl = apiBaseUrl + "/Order/GetCustomerOrders?";

class AllOrdersService {
  Future getAllOrders(
      {required BuildContext context,
      required int customerId,
      int? days}) async {
    try {
      days ??= 0;
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: getAllCustUrl + "CustomerId=$customerId" + "&days=$days");
      if (res != null) {
        SaleRepOrdersModel customersModel = SaleRepOrdersModel.fromJson(res);
        Provider.of<AllOrdersProvider>(context, listen: false)
            .update(newOrders: customersModel.data);
        return true;
      }
    } catch (err) {
      print("Exception in Get All Customers Service $err");
      return null;
    }
  }
}
