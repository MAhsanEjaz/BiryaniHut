import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/salesrep_orders_model.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';
import 'package:shop_app/storages/login_storage.dart';

class SalesRepOrdersService {
  Future getSaleRepOrders({required BuildContext context}) async {
    var salesrepId = LoginStorage().getUserId();
    try {
      String saleRepOrderUrl =
          "$apiBaseUrl/Order/SaleRepCustomerOrders/$salesrepId";
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: saleRepOrderUrl);
      if (res != null) {
        SaleRepOrdersModel saleRepOrders = SaleRepOrdersModel.fromJson(res);

        if (saleRepOrders.data == null || saleRepOrders.data!.isEmpty) {
          CustomSnackBar.failedSnackBar(
              context: context, message: "No Orders yet!");
        } else {
          Provider.of<SaleRepOrdersProvider>(context, listen: false)
              .updateSaleRapOrder(newRepOrders: saleRepOrders.data);
        }
      } else {
        CustomSnackBar.failedSnackBar(
            context: context, message: "No Orders yet!");
      }
    } catch (err) {
      print("Exception in Sale Rep Orders service $err");
      CustomSnackBar.failedSnackBar(
          context: context, message: "Something went wrong");
    }
  }
}
