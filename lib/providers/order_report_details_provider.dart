import 'package:flutter/cupertino.dart';

import '../models/order_report_details_model.dart';

class OrderReportDetailsProvider extends ChangeNotifier{
  OrderReportDetailsModel? reportDetailsModel;

  updateOrders({OrderReportDetailsModel? newDetailsModel}) {
    reportDetailsModel=newDetailsModel;
    notifyListeners();
  }
}