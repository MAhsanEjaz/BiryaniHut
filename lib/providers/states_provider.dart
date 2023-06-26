import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/states_model.dart';

class StatesProvider extends ChangeNotifier {
  List<AllStatesModel>? statesData = [];

  getAllStates({List<AllStatesModel>? newStatesData}) {
    statesData = newStatesData;
    notifyListeners();
  }
}
