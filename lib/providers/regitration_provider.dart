import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/regitration_model.dart';

class RegistrationProvider extends ChangeNotifier {
  RegistrationModel? registrationModel;

  userRegistration({RegistrationModel? newRegistrationModel}) {
    registrationModel = newRegistrationModel;
    notifyListeners();
  }
}
