import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/provider/categories_provider.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/models/categoriies_model.dart';
import 'package:shop_app/providers/categories_provider.dart';

class NewCategoriesService {
  Future categoriesService({required BuildContext context}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: '$apiBaseUrl/Category/GetAllCategory');

      if (res != null) {
        CategoriesModel categoriesModel = CategoriesModel.fromJson(res);

        Provider.of<NewCategoriesProvider>(context, listen: false)
            .getCategories(newModel: categoriesModel.data);
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
