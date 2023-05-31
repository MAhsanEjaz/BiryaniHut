import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/customer_products_widget.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/models/resseller_customers_model.dart';
import 'package:shop_app/services/product_remove_favourite_service.dart';

import '../../helper/custom_loader.dart';
import '../../models/favourites_products_model.dart';
import '../../providers/cust_favourites_product_provider.dart';
import '../../services/customer_favourtes_products_service.dart';
import '../../storages/login_storage.dart';
import '../screens/product_details/customer_product_detail_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesPage> {
  _getCustFavProdHandler() async {
    CustomLoader.showLoader(context: context);
    await CustFavProductsService().getCustFavProd(
        context: context, customerId: LoginStorage().getUserId());
    CustomLoader.hideLoader(context);
  }

  LoginStorage loginStorage = LoginStorage();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCustFavProdHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Favourites",
        style: TextStyle(color: Colors.black),
      )),
      body: SingleChildScrollView(
        child: Consumer<CustFavouritesProductsProvider>(
            builder: (context, product, _) {
          List<Widget> widgets = [];
          product.favProd != null
              ? product.favProd!.forEach((element) {
                  widgets.add(
                    CustomerProductsWidget(
                      favouriteTap: () async {
                        CustomLoader.showLoader(context: context);
                        bool res = await DeleteFavouriteService()
                            .deleteFavouriteService(
                                context: context,
                                customerId: loginStorage.getUserId(),
                                productId: element.productId);
                        _getCustFavProdHandler();

                        if (res == true) {
                          showToast('Product remove from favourite');
                        }

                        CustomLoader.hideLoader(context);
                      },
                      heartColor: true,
                      isReseller: false,
                      productData: element,
                    ),
                  );
                })
              : const SizedBox();
          return product.favProd!.isEmpty
              ? const Center(child: Text("No Favourite product"))
              : Wrap(
                  children: widgets,
                );
        }),
      ),
    );
  }
}

// class CustomerFavProductWidget extends StatelessWidget {
//   final bool isReseller;
//   final ProductData fav;

//   const CustomerFavProductWidget(
//       {Key? key, required this.isReseller, required this.fav})
//       : super(key: key);

//   // CustomerCartStorage cartStorage = CustomerCartStorage();

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductDetailsPage(
//                 customerId: LoginStorage().getUserId(),
//                 isRep: false,
//                 isShowCartBtn: true,
//                 data: fav,
//               ),
//             ));
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(14.0),
//           child: Container(
//             height: 220,
//             width: MediaQuery.of(context).size.width / 2.2,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: NetworkImage(getImageUrl(fav.productImagePath)),
//                     fit: BoxFit.cover)),
//             child: Container(
//               decoration: const BoxDecoration(
//                   gradient:
//                       LinearGradient(colors: [Colors.black26, Colors.white24])),
//               child: Column(
//                 children: [
//                   const Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           child: Text(
//                             fav.productName,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           width: 100,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
