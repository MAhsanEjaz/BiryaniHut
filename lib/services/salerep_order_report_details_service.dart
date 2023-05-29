import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/salesrep_orders_model.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';

import '../models/order_report_details_model.dart';
import '../providers/order_report_details_provider.dart';

const String orderReportDetailsUrl =
    apiBaseUrl + "/Order/GetOrderProductsDetails";

class SaleRepOrderReportDetailsService {
  Future getOrders(
      {required BuildContext context, required int orderId}) async {
    // try {
    print("Url $orderReportDetailsUrl");
    var res = await CustomGetRequestService().httpGetRequest(
        context: context, url: orderReportDetailsUrl + "/$orderId");
    if (res != null) {
      OrderReportDetailsModel ordersModel =
          OrderReportDetailsModel.fromJson(res);
      Provider.of<OrderReportDetailsProvider>(context, listen: false)
          .updateOrders(newDetailsModel: ordersModel);
      return true;
    }
    // } catch (err) {
    // print("Exception in salerep order report details service $err");
    // return null;
    // }
  }
}
