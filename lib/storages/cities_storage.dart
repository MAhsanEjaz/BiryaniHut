import 'dart:developer';

import 'package:hive_flutter/adapters.dart';

class HiveCities {
  final box = Hive.box('cities_hive');

  void setCities({required String cities}) {
    log("cities in hive = $cities");
    box.put("cities", cities);
  }

  String getCities() {
    if(box.get("cities")==null){
      return '';
    }
    return box.get("cities");
  }
}
