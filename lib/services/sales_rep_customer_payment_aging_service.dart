import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../models/sales_rep_customer_payment_aging_model.dart';
import '../providers/salesrep_customer_payment_aging_provider.dart';

const String paymentAgingUrl =
    apiBaseUrl + "/Order/SaleRepCustomerPaymentsAging";

class SalesRepCustomerPaymentAgingService {
  Future getPayments({required BuildContext context}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: paymentAgingUrl + "/${LoginStorage().getUserId()}");
      if (res != null) {
        SalesRepCustomerPaymentAgingModel paymentAgingModel =
            SalesRepCustomerPaymentAgingModel.fromJson(res);
        Provider.of<SalesRepCustomerPaymentAgingProvider>(context,
                listen: false)
            .updateList(newAging: paymentAgingModel.data);
        return true;
      }
    } catch (err) {
      print("Exception in SaleRep Customer Payment Aging Service $err");
      return null;
    }
  }
}
