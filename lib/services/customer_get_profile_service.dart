import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/customer_profile_model.dart';
import 'package:shop_app/providers/customer_profile_provider.dart';

class CustomerGetService {
  Future customerGetService(
      {required BuildContext context, required int id}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url: '$apiBaseUrl/Customer/GetCustomerDataById/$id');

      if (res != null) {
        CustomerProfileModel customerProfileModel =
            CustomerProfileModel.fromJson(res);

        Provider.of<CustomerProfileProvider>(context, listen: false)
            .getProfileData(newcCustomerProfileModel: customerProfileModel);
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
