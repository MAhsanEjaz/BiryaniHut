import 'package:flutter/cupertino.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';

class CustomerDeleteService {
  Future customerDeleteService({required BuildContext context,
    required int custId,
    required int selId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url:
          'http://38.17.51.206:8070/api/Customer/RequestDeleteCustomer?custId=$custId&saleRepId=$selId');

      if (res != null) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
