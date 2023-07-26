import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/models/sub_category_model.dart';
import 'package:shop_app/providers/sub_category_provider.dart';

class SubCategoryService {
  Future subCategoryService({required BuildContext context,required int productId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: '$apiBaseUrl/Product/ProductGetByCatId/$productId');

      if (res != null) {
        ProductsModel subCategoryModel = ProductsModel.fromJson(res);

        Provider.of<SubCategoryProvider>(context, listen: false)
            .getSubCategory(newModel: subCategoryModel.data);
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
