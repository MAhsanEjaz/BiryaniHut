import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/salesrep_profile_model.dart';

class SalesrepProfileProvider extends ChangeNotifier {
  SalesrepProfileModel? repProfileModel;

  updateRepProfileProvider({SalesrepProfileModel? model}) {
    repProfileModel = model;
    notifyListeners();
  }
}
