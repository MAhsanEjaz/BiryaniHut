import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/customers_search_model.dart';
import 'package:shop_app/providers/customers_search_provider.dart';

import '../models/resseller_customers_model.dart';

const String custSearchUrl = "$apiBaseUrl/Customer/Search?";

class CustomersSearchService {
  Future searchCustomer(
      {required BuildContext context, required String name}) async {
    try {
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: custSearchUrl + "name=$name");
      if (res != null) {
        ResellerCustomersModel customersSearchModel =
            ResellerCustomersModel.fromJson(res);
        Provider.of<CustomersSearchProvider>(context, listen: false)
            .updateCustomer(newCustomer: customersSearchModel.data);
        return true;
      } else {
        return null;
      }
    } catch (err) {
      print("Exception in customer search service $err");
      return null;
    }
  }
}
