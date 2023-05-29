import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/models/salesrep_profile_model.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/providers/user_data_provider.dart';
import '../models/user_model.dart';
import '../storages/login_storage.dart';

class SalesrepProfileDataService {
  LoginStorage storage = LoginStorage();

  Future repProfileService({required BuildContext context}) async {
    try {
      String apiUrl =
          "$apiBaseUrl/SaleRep/GetSaleRepById/${storage.getUserId()}";

      log("SalesrepProfileDataService api = $apiUrl");
      var res = await CustomGetRequestService().httpGetRequest(
        context: context,
        url: apiUrl,
      );

      log("SalesrepProfileDataService responce = $res");

      if (res["data"] != null) {
        SalesrepProfileModel model = SalesrepProfileModel.fromJson(res);

        Provider.of<SalesrepProfileProvider>(context, listen: false)
            .updateRepProfileProvider(model: model);

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

// if (userModel.data != null) {
//   storage.setIsLogin(login: true);
//   storage.setUserFirstName(fName: userModel.data!.firstName);
//   storage.setUserLastName(lName: userModel.data!.lastName);
//   storage.setUserId(id: userModel.data!.id);
//   storage.setUserEmail(email: userModel.data!.email);
//   if (userModel.data!.roleId == 1) {
//     storage.setUserType(usertype: "customer");
//   } else {
//     storage.setUserType(usertype: "salesrep");
//   }
//
//   log("Login Successfully");
//   if (userModel.data != null) {
//     return true;
//   } else {
//     return false;
//   }
// } else {
//   return false;
// }
