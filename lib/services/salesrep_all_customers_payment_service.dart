import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';

import '../models/salesrep_all_customer_payment_model.dart';
import '../providers/salesrep_all_customer_payment_provider.dart';

const String repCustomersPaymentsUrl = "$apiBaseUrl/Customer/";

class SalesRepAllCustomersPaymentsService {
  Future getCustomersPaymentsList(
      {required BuildContext context,
      required int saleRepId,
      required int days}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: repCustomersPaymentsUrl +
              "SaleRepCustomerPayments/$saleRepId/$days");
      if (res != null) {
        SalerepAllCustomerPaymentModel paymentModel =
            SalerepAllCustomerPaymentModel.fromJson(res);
        Provider.of<SalesrepAllCustomersPaymentsProvider>(context,
                listen: false)
            .updateList(newCustList: paymentModel.data);
        return true;
      }
    } catch (err) {
      print("Exception in Sale Rep All Customer Payments Service $err");
      return null;
    }
  }
}
