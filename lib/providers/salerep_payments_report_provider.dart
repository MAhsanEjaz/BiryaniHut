

import 'package:flutter/cupertino.dart';

import '../models/salerep_payments_report_model.dart';

class SaleRepPaymentsReportsProvider extends ChangeNotifier{
  SaleRepPaymentsReportModel? report;
  updatePaymentsReports({SaleRepPaymentsReportModel? newPayReport}) {
    report=newPayReport;
    notifyListeners();
  }
}