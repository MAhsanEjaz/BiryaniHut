import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';

class DeleteFavouriteService {
  Future deleteFavouriteService(
      {required BuildContext context, int? customerId, int? productId}) async {
    try {
      Map body = {
        "customerId": customerId,
        "productId": productId,
        "status": true
      };

      var res = await CustomPostRequestService().httpPostRequest(
          context: context,
          url: '$apiBaseUrl/Customer/RemoveFromFavorite',
          body: body);

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
