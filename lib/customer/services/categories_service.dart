import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/helper/custom_post_request.dart';

import '../models/categories_model.dart';
import '../provider/categories_provider.dart';

const String catUrl = apiBaseUrl + "/Category/GetAllCategory";

class CategoriesService {
  Future getCat({required BuildContext context}) async {
    try {
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: catUrl);
      if (res != null) {
        CustomerAllCategoriesModel categoriesModel =
            CustomerAllCategoriesModel.fromJson(res);
        Provider.of<CategoriesProvider>(context, listen: false)
            .updateCat(newCat: categoriesModel.data);
        return true;
      }
    } catch (Err) {
      print("Exception in Categories Service $Err");
      return null;
    }
  }
}
