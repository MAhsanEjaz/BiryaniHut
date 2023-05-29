import 'package:flutter/foundation.dart';
import 'package:shop_app/models/timelines_model.dart';

class TimeLinesProvider extends ChangeNotifier {
  List<TimeLines>? timeLines = [];
  updateTimeLines({List<TimeLines>? newTimeLines}) {
    timeLines = newTimeLines;
    notifyListeners();
  }
}
