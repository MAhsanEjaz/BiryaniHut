import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/products_search_model.dart';
import 'package:shop_app/providers/products_search_provider.dart';

import '../models/products_model.dart';

const String prodSearchUrl = "$apiBaseUrl/Product/ProductSearch?";

class ProductsSearchService {
  Future searchProd(
      {required BuildContext context, required String prodName}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: prodSearchUrl + "name=$prodName");
      if (res != null) {
        ProductsModel productsSearchModel = ProductsModel.fromJson(res);
        Provider.of<ProductSearchProvider>(context, listen: false)
            .updateSearch(newSearch: productsSearchModel.data);
        return true;
      } else {
        return null;
      }
    } catch (err) {
      print("Exception in Product Search Service $err");
      return null;
    }
  }
}
