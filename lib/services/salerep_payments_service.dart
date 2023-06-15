import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/salerep_payments_report_model.dart';
import 'package:shop_app/providers/salerep_payments_report_provider.dart';

const String paymentsUrl = '$apiBaseUrl/Customer/CustomerPaymentHistory/';

class SaleRepPaymentsReportService {
  Future getPayments(
      {required BuildContext context,
      required int customerId,
      required int days}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: paymentsUrl + "$customerId/$days");
      if (res != null) {
        SaleRepPaymentsReportModel paymentsReport =
            SaleRepPaymentsReportModel.fromJson(res);
        Provider.of<SaleRepPaymentsReportsProvider>(context, listen: false)
            .updatePaymentsReports(newPayReport: paymentsReport);
        return true;
      }
    } catch (err) {
      print("Exception in SaleRep Payments Reports Service $err");
      return null;
    }
  }
}
