import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductsService {
  Future getProducts({required BuildContext context}) async {
    try {
      const String prodUrl = "$apiBaseUrl/Product/ProductGet";
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: prodUrl);
      if (res != null) {
        ProductsModel prod = ProductsModel.fromJson(res);

        Provider.of<ProductsProvider>(context, listen: false)
            .updateProd(newProd: prod.data);

        return true;
      } else {
        return null;
      }
    } catch (err) {
      print("Exception in get products service $err");
      return ProductsModel(status: 0, message: "Something went wrong");
    }
  }
}
