// ignore_for_file: empty_catches

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/customer_custom_bottom_nav_bar.dart';
import 'package:shop_app/customer/screens/sub_category_screen.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/customer_products_widget.dart';
import 'package:shop_app/helper/custom_get_request_service.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/categoriies_model.dart';
import 'package:shop_app/providers/categories_provider.dart';
import 'package:shop_app/providers/payment_get_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/services/categories_service.dart';
import 'package:shop_app/services/customer_favourtes_products_service.dart';
import 'package:shop_app/services/customer_get_profile_service.dart';
import 'package:shop_app/services/get_payment_service.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/storages/customer_cart_storage.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/widgets/custom_textfield.dart';
import '../../../components/categories_screen.dart';
import '../../../constants.dart';
import '../../../helper/custom_loader.dart';
import '../../../models/products_model.dart';
import '../../../providers/counter_provider.dart';
import '../../services/categories_service.dart';
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

  _getCustFavProdHandler() async {
    CustomLoader.showLoader(context: context);
    await CustFavProductsService().getCustFavProd(
        context: context, customerId: LoginStorage().getUserId());
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      categoriesHandler();
      _getCustFavProdHandler();
      initializeStripe();
      // customerGetDataHandler();
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

  saleRepGetPaymentKeyHandler() async {
    await GetPaymentKeyService().getPaymentKeyService(
        context: context,
        salRepId: loginStorage.getSalesRepId() ?? loginStorage.getUserId());
  }

  Future<void> initializeStripe() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      String? stripeApiKey;
      var paymentProvider =
          Provider.of<PaymentGetProvider?>(context, listen: false);

      if (paymentProvider != null &&
          paymentProvider.paymentKeyGetModel != null &&
          paymentProvider.paymentKeyGetModel!.data!.publishableTestKey !=
              null) {
        stripeApiKey =
            paymentProvider.paymentKeyGetModel!.data!.publishableTestKey;
        Stripe.publishableKey = stripeApiKey!;
        await Stripe.instance.applySettings();
        print('stripeApiKey$stripeApiKey');
      } else {
        Stripe.publishableKey =
            'pk_test_51Mt7WuFPO4xgbPFkTVVahnMEIb9IZPgkOkPIVL68Nj6nBeJVJD9gIJcekJuHNh35QV6JH6hQ01VJY7ytkvrxISre00U8vrdKF1';
        await Stripe.instance.applySettings();
      }
    } catch (err) {
      print(err);
    }
  }

  List<CategoriesData> catModel = [];

  categoriesHandler() async {
    CustomLoader.showLoader(context: context);
    await NewCategoriesService().categoriesService(context: context);

    catModel =
        Provider.of<NewCategoriesProvider>(context, listen: false).model!;

    print('categoriesData--->$catModel');
    CustomLoader.hideLoader(context);
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
                                      onTap: onClear,
                                      child: const Icon(Icons.clear))
                                  : const SizedBox.shrink(),
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

                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          for (int i = 0; i < catModel.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9.0, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              SubCategoryScreen(
                                                categoryName:
                                                    catModel[i].categoryName!,
                                                productId:
                                                    catModel[i].categoryId!,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(
                                      //     color: Colors.blue.shade100),
                                      color: Colors.primaries[i].shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15),
                                    child: Text(
                                      catModel[i].categoryName!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: getProportionateScreenWidth(10)),
                              // const DiscountBanner(),
                              // const Categories(),
                              // SpecialOffers(),
                              // SizedBox(height: getProportionateScreenWidth(10)),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.0),
                                child: Text(
                                  'All Products',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                      ],
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
          for (var element in productsList!) {
            log(" element price = ${element.salePrice}");
            widgets.add(CustomerProductsWidget(
              isReseller: false,
              productData: element,
            ));

            // widgets.add(Container(
            //   color: Colors.redAccent,
            // ));
          }
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

  customerGetDataHandler() async {
    CustomLoader.showLoader(context: context);
    await CustomerGetService()
        .customerGetService(context: context, id: loginStorage.getUserId());

    // Provider.of<CustomerProfileProvider>(context, listen: false)
    //     .customerProfileModel;

    CustomLoader.hideLoader(context);
  }
}
