import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/providers/regitration_provider.dart';

import '../models/regitration_model.dart';

class RegisterService {
  Future registerService({
    required BuildContext context,
    required Map body,
    required bool isReseller,
  }) async {
    try {
      log("body in register = $body");
      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          body: body,
          url: isReseller == true
              ? "$apiBaseUrl/SaleRep/RegisterCustomerBySaleRep"
              : "$apiBaseUrl/Customer/RegisterCustomer");

      if (res['errors'] == null) {
        RegistrationModel registrationModel = RegistrationModel.fromJson(res);
        Provider.of<RegistrationProvider>(context, listen: false)
            .userRegistration(newRegistrationModel: registrationModel);

        return true;
      } else {
        return false;
      }
    } catch (err) {
      log("exception at register user time = ${err.toString()}");
      return false;
    }
  }
}
