import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/providers/timelines_provider.dart';

import '../models/timelines_model.dart';

const String timeLinesUrl = "$apiBaseUrl/Product/BroadcastGet";

class TimeLinesService {
  Future getTimeLines({required BuildContext context}) async {
    try {
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: timeLinesUrl);
      if (res != null) {
        TimeLinesModel timeLines = TimeLinesModel.fromJson(res);
        Provider.of<TimeLinesProvider>(context, listen: false)
            .updateTimeLines(newTimeLines: timeLines.data);
        return true;
      } else {
        return null;
      }
    } catch (err) {
      print("Exception in timelines service $err");
      return null;
    }
  }
}
