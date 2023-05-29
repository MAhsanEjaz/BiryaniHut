import 'package:flutter/cupertino.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_post_request.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

const String addToFavUrl = "$apiBaseUrl/Customer/AddToFavorite";

class AddToFavouriteService {
  Future addToFav(
      {required BuildContext context,
      required int customerId,
      required int productId,
      required String date}) async {
    try {
      Map _body = {
        "customerId": customerId,
        "productId": productId,
        "dateTime": "$date"
      };
      print("Body $_body ");
      var res = await CustomPostRequestService()
          .httpPostRequest(context: context, url: addToFavUrl, body: _body);
      if (res != null) {
        print("Added To Favourites Successfully");
        CustomSnackBar.showSnackBar(
            context: context, message: "Added To Favourites Successfully");

        return true;
      } else {
        print("Added To Cart Unsucceddfull");
        // CustomSnackBar.showSnackBar(context: context, message: "Already in Fav");
        return null;
      }
    } catch (err) {
      print("Exception in Add To Cart Service $err");
      return null;
    }
  }
}
