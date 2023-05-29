import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/providers/user_data_provider.dart';
import '../models/user_model.dart';
import '../storages/login_storage.dart';

class LoginApiService {
  LoginStorage storage = LoginStorage();

  Future loginService(
      {required BuildContext context, String? email, String? password}) async {
    try {
      Map body = {"email": email, "password": password};

      log("login body = $body");

      // const String loginUrl = "$baseUrl/api/login/authUser";
      const String loginUrl = "$apiBaseUrl/login/authUser";

      var res = await CustomPostRequestService()
          .httpPostRequest(context: context, url: loginUrl, body: body);

      log("login responce = $res");

      if (res["data"] != null) {
        UserModel userModel = UserModel.fromJson(res);
        Provider.of<UserDataProvider>(context, listen: false)
            .updateUser(newUser: userModel);
        storage.setIsLogin(login: true);
        storage.setUserFirstName(fName: userModel.data!.firstName!);
        storage.setUserLastName(lName: userModel.data!.lastName!);
        storage.setUserId(id: userModel.data!.id!);
        storage.setUserEmail(email: userModel.data!.email!);
        storage.setAdress(adress: userModel.data!.address!);
        storage.setPhone(phone: userModel.data!.phone!);
        if (userModel.data!.roleId == 1) {
          storage.setUserType(usertype: "customer");
          storage.setSalesRepId(repId: userModel.data!.saleRepId!);
          storage.setSalesRepName(repName: userModel.data!.saleRepName!);
        } else {
          storage.setUserType(usertype: "salesrep");
        }
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
