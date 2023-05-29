import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import '../models/products_model.dart';
import '../providers/cust_favourites_product_provider.dart';

class CustFavProductsService {
  Future getCustFavProd(
      {required BuildContext context, required int customerId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context,
          url:
              apiBaseUrl + "/Customer/GetCustomerFavoriteProducts/$customerId");
      if (res != null) {
        ProductsModel favProd = ProductsModel.fromJson(res);
        Provider.of<CustFavouritesProductsProvider>(context, listen: false)
            .updateFav(newFavProd: favProd.data);
        // return true;
      } else {
        // return null;
      }
    } catch (err) {
      print("Exception in get customer favourites product service $err");
      // return null;
    }
  }
}
