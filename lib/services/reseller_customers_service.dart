import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/providers/reseller_customer_provider.dart';
import 'package:shop_app/providers/user_data_provider.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../models/resseller_customers_model.dart';

class ResellerCustomerService {
  Future getCustomerList(
      {required BuildContext context, required bool isReport}) async {
    LoginStorage loginStorage = LoginStorage();
    log('id${loginStorage.getUserId()}');

    var id = loginStorage.getUserId();
    // Provider.of<UserDataProvider>(context, listen: false).user!.data!.id;

    try {
      // String resellerCustomerUrl = "$baseUrl/SaleRep/SaleRepCustomers/1}";
      String resellerCustomerUrl = "$apiBaseUrl/SaleRep/SaleRepCustomers/$id";

      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: resellerCustomerUrl);
      if (res != null) {
        // List<ResellerCustomersList> reseller = [];
        ResellerCustomersModel resellerCustomers =
            ResellerCustomersModel.fromJson(res);
        Provider.of<ResellerCustomerProvider>(context, listen: false)
            .updateCust(newCust: resellerCustomers.data);

        if (isReport) {
          if (resellerCustomers.data!.isNotEmpty) {
            resellerCustomers.data!.insert(
                0,
                SalesrepCustomerData(
                    id: 1084,
                    firstName: "Select Customer",
                    lastName: "",
                    address: "",
                    city: "",
                    customerImage: "",
                    customerImagePath: "",
                    customerOrders: "",
                    location: "",
                    login: null,
                    loginId: 0,
                    phone: "",
                    saleRep: "",
                    saleRepID: 0,
                    salonName: "",
                    state: ""));
          }
        }
        // for (var k in resellerCustomers.data!) {
        //   reseller.add(k);
        // }
        // Provider.of<ResellerCustomerProvider>(context, listen: false)
        //     .updateCust(newCust: resellerCustomers.data);
        return true;
        log("data returned for customers =  ${resellerCustomers.data.toString()}");
      } else {
        CustomSnackBar.failedSnackBar(
            context: context, message: "No Customer found");
      }
    } catch (err) {
      log("Exception in reseller customers service $err");
      CustomSnackBar.failedSnackBar(
          context: context, message: "Something went wrong");
    }
  }
}
