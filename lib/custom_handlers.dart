import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/services/products_search_service.dart';
import 'package:shop_app/services/products_service.dart';

import 'helper/custom_loader.dart';

// getProductsHandler(BuildContext context)async{
//   CustomLoader.showLoader(context: context);
//  await ProductsService().getProducts(context: context);
//  print("Length ${Provider.of<ProductsProvider>(context,listen: false).prod!.length}");
//   CustomLoader.hideLoader(context);
// }

productSearchHandler({required BuildContext context,required String searchText}) async {
  CustomLoader.showLoader(context: context);
  await ProductsSearchService()
      .searchProd(context: context, prodName: searchText);
  CustomLoader.hideLoader(context);
}