import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';

class UpdateCustomerService {
  Future updateCustomerService(
      {required BuildContext context,
      isSaleREpProfile = false,
      int? customerId,
      String? firstName,
      String? lastName,
      String? address,
      String? companyName,
      String? city,
      String? state,
      String? email,
      String? salonName,
      String? phone,
      String? saleRepImage}) async {
    try {
      Map body = {
        isSaleREpProfile == false ? "customerId" : "id": customerId,
        "firstName": firstName,
        "email": email,
        "city": city,
        "companyName":companyName,
        "state": state,
        "salonName": salonName,
        "lastName": lastName,
        "address": address,
        "phone": phone,
        isSaleREpProfile == false ? "customerImage" : "saleRepImageMobile":
            saleRepImage
      };
      log("update customer body = $body");
      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          url: isSaleREpProfile == false
              ? '$apiBaseUrl/Customer/UpdateCustomer'
              : '$apiBaseUrl/SaleRep/UpdateSaleRep',
          body: body);

      if (res != null) {
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
