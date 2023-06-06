import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/customer_custom_bottom_nav_bar.dart';
import 'package:shop_app/customer/screens/home/components/discount_banner.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/customer_products_widget.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/services/customer_get_profile_service.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/storages/customer_cart_storage.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../../../constants.dart';
import '../../../helper/custom_loader.dart';
import '../../../models/products_model.dart';
import '../../../providers/counter_provider.dart';
import '../cart/customer_cart_page.dart';
import 'components/icon_btn_with_counter.dart';

class CustomerHomePage extends StatefulWidget {
  static String routeName = "/home";

  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  TextEditingController searchCont = TextEditingController();

  CustomerCartStorage cartStorage = CustomerCartStorage();

  List<String> list = [];
  int value = 0;

  List<ProductData>? productsList = [];

  ////

  List<ProductData> myProducts = [];
  List<ProductData> callProducts = [];

  searchProducts(String query) {
    final myQuery = query.toLowerCase();

    setState(() {
      callProducts = myProducts.where((element) {
        final name = element.productName.toLowerCase();
        return name.contains(myQuery);
      }).toList();
    });
  }

  onClear() {
    callProducts = myProducts;
    searchCont.clear();
    setState(() {});
  }

  LoginStorage loginStorage = LoginStorage();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (cartStorage.getCartItems() != null) {
        list = cartStorage.getCartItems()!;
        log("list length = ${list.length}");

        Provider.of<CartCounterProvider>(context, listen: false)
            .setCount(list.length);
      }

      await getProducts(context: context);

      final productProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      myProducts = productProvider.prod!;
      callProducts = myProducts;
    });

    super.initState();
  }

  List<Widget> widgets = [];

  List<ProductData> clearProducts = [];

  // bool showSearch = false;

  // List<ProductData> productsSearchList = [];

  String query = '';

  List<ProductData> get searchProduct {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final queryLower = query.toLowerCase();
    return productProvider.prod!.where((element) {
      final nameLower = element.productName.trim().toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
  }

  DateTime? _lastPressedTime;

  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    if (_lastPressedTime == null ||
        currentTime.difference(_lastPressedTime!) >
            const Duration(seconds: 1)) {
      _lastPressedTime = currentTime;

      showToast('Double press to exit');

      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<ProductsProvider>(builder: (context, data, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              suffixWidget: searchCont.text.isNotEmpty
                                  ? InkWell(
                                      onTap: onClear, child: Icon(Icons.clear))
                                  : SizedBox(),
                              controller: searchCont,
                              hint: "Search Products",
                              prefixWidget: const Icon(Icons.search),
                              isEnabled: true,
                              onChange: searchProducts,

                              // onSubmit: (value) {
                              //   // productSearchHandler(
                              //   //     context: context, searchText: searchCont.text);
                              //   // showSearch = true;
                              //   //
                              //   // setState(() {
                              //   //   print("Show Search $showSearch");
                              //   // });
                              // },
                              // suffixWidget: showSearch
                              //     ? IconButton(
                              //         onPressed: () {
                              //           showSearch = false;
                              //
                              //           setState(() {
                              //             searchCont.clear();
                              //           });
                              //         },
                              //         icon: const Icon(Icons.clear))
                              //     : const SizedBox()
                            ),
                          ),
                        ),
                        Consumer<CartCounterProvider>(
                            builder: (context, cart, _) {
                          return IconBtnWithCounter(
                              numOfitem: cart.count,
                              svgSrc: "assets/icons/Cart Icon.svg",
                              press: () {
                                FocusScope.of(context).unfocus();
                                // if (list.length > 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomerCartPage()));
                                // } else {
                                //   showToast("Cart Empty yet !");
                                // showSnackbar(
                                //     context: context,
                                //     title: "Cart Empty",
                                //     desc: "Nothing yet in cart");
                                // }
                              });
                        }),
                        const SizedBox(
                          width: 6,
                        )
                      ],
                    ),

                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: getProportionateScreenWidth(10)),
                          const DiscountBanner(),
                          // const Categories(),
                          // SpecialOffers(),
                          // SizedBox(height: getProportionateScreenWidth(10)),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Text(
                              'All Products',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),

                    callProducts.isNotEmpty
                        ? Wrap(
                            children: [
                              for (var product in callProducts)
                                CustomerProductsWidget(
                                  isReseller: false,
                                  productData: product,
                                )
                            ],
                          )
                        : const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Product not found',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )

                    // Column(children: [
                    //        Padding(
                    //          padding: EdgeInsets.symmetric(
                    //              horizontal: getProportionateScreenWidth(15)),
                    //          child:
                    //              SectionTitle(title: "All Products", press: () {}),
                    //        ),
                    //        if (widgets.isNotEmpty)
                    //          Center(
                    //            child: Wrap(
                    //              alignment: WrapAlignment.start,
                    //              crossAxisAlignment: WrapCrossAlignment.center,
                    //              children: widgets.toList(),
                    //            ),
                    //          ),
                    //        // : const CircularProgressIndicator(),
                    //        SizedBox(height: getProportionateScreenWidth(30)),
                    //      ]),
                    //    Consumer<ProductSearchProvider>(
                    //        builder: (context, search, _) {
                    //        List<Widget> widgets = [];
                    //        search.prodSearch!.isNotEmpty && search.prodSearch != null
                    //            ? search.prodSearch!.forEach((element) {
                    //                widgets.add(CustomerProductsWidget(
                    //                  isReseller: false,
                    //                  productData: element,
                    //                )
                    //                );
                    //              })
                    //            : Container(
                    //                alignment: Alignment.center,
                    //                child: const Text(
                    //                  "No Product Available",
                    //                  style: TextStyle(color: kPrimaryColor),
                    //                ),
                    //              );
                    //        return Wrap(
                    //          children: widgets,
                    //        );
                    //      }),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                const CustomCustomBottomNavBar(selectedMenu: MenuState.home),
          ),
        ),
      );
    });
  }

  Future getProducts({required BuildContext context}) async {
    CustomLoader.showLoader(context: context);

    try {
      const String prodUrl = "$apiBaseUrl/Product/ProductGet";
      var res = await CustomGetRequestService()
          .httpGetRequest(context: context, url: prodUrl);
      if (res != null) {
        ProductsModel prod = ProductsModel.fromJson(res);

        // Provider.of<ProductsProvider>(context, listen: false)
        //     .updateProd(newProd: prod.data);
        // setState(() {});
        // CustomLoader.hideLoader(context);
        // return true;

        productsList = prod.data;

        if (productsList!.isNotEmpty) {
          productsList!.forEach((element) {
            log(" element price = ${element.price}");
            widgets.add(CustomerProductsWidget(
              isReseller: false,
              productData: element,
            ));

            // widgets.add(Container(
            //   color: Colors.redAccent,
            // ));
          });
        }
        CustomLoader.hideLoader(context);

        Provider.of<ProductsProvider>(context, listen: false)
            .updateProd(newProd: prod.data);

        return true;
      } else {
        // return null;
      }
    } catch (err) {
      print("Exception in get products service $err");
      return ProductsModel(status: 0, message: "Something went wrong");
    }
  }
}
