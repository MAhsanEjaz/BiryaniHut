import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/payment_key_get_model.dart';

class PaymentGetProvider extends ChangeNotifier {
  PaymentKeyGetModel? paymentKeyGetModel;

  getPaymentData({PaymentKeyGetModel? newModel}) {
    paymentKeyGetModel = newModel;
    notifyListeners();
  }
}
