import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/salesrep_products_widget.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/custom_handlers.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/sales%20rep/salesrep_cart_page.dart';
import 'package:shop_app/services/products_service.dart';
import '../customer/screens/home/components/icon_btn_with_counter.dart';
import '../helper/custom_loader.dart';
import '../providers/counter_provider.dart';
import '../providers/products_provider.dart';
import '../providers/products_search_provider.dart';
import '../services/products_search_service.dart';
import '../storages/salesrep_cart_storage.dart';
import '../widgets/custom_textfield.dart';

class SalesRepProductsPage extends StatefulWidget {
  SalesRepProductsPage({
    Key? key,
    required this.isReseller,
    this.customerName,
    required this.email,
    required this.phone,
    required this.customerId,
  }) : super(key: key);
  final bool isReseller;
  final int customerId;
  String? customerName;
  String email;
  String phone;

  @override
  State<SalesRepProductsPage> createState() => _SalesRepProductsPageState();
}

class _SalesRepProductsPageState extends State<SalesRepProductsPage> {
  // final searchCont = TextEditingController();

  SalesrepCartStorage cartStorage = SalesrepCartStorage();
  List<String> list = [];

  List<ProductData> myProducts = [];
  List<ProductData> callProducts = [];

  getProductsHandler(BuildContext context) async {
    CustomLoader.showLoader(context: context);
    await ProductsService().getProducts(context: context);
    final currentProductsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    myProducts = currentProductsProvider.prod!;

    callProducts = myProducts;

    setState(() {});
    print('myList$myProducts');
    print(
        "Length ${Provider.of<ProductsProvider>(context, listen: false).prod!.length}");
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProductsHandler(context);
    });
    if (cartStorage.getCartItems(customerId: widget.customerId) != null) {
      list = cartStorage.getCartItems(customerId: widget.customerId)!;
      log("listlist = $list");
      Provider.of<CartCounterProvider>(context, listen: false)
          .setCount(list.length);
    }
    super.initState();
  }

  bool showSearch = false;

  String query = '';

  productSearchFunction(String query) {
    final queryLower = query.toLowerCase();
    setState(() {
      callProducts = myProducts.where((element) {
        final name = element.productName.trim().toLowerCase();
        return name.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(builder: (context, data, _) {
      myProducts = data.prod!;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: iconTheme,
            backgroundColor: appColor,
            // leading: Icon(Icons.back),
            title: const Text(
              "Products",
              // style: custStyle,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              NavigatorWidget(),
              if (widget.customerName != null)
                Row(
                  children: [
                    Consumer<CartCounterProvider>(builder: (context, cart, _) {
                      return IconBtnWithCounter(
                          numOfitem: cart.count,
                          svgSrc: "assets/icons/Cart Icon.svg",
                          press: () {
                            // if (list.length > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesRepCartPage(
                                    customerName: widget.customerName!,
                                    customerId: widget.customerId,
                                    phone: widget.phone,
                                    email: widget.email,
                                  ),
                                ));
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
                      width: 10,
                    ),
                  ],
                ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                if (widget.customerName != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(
                          width: 10,
                        ),
                        RichText(
                            text: TextSpan(
                                text: "You are ordering for ",
                                style: custStyle,
                                children: [
                              TextSpan(
                                  text: widget.customerName, style: idStyle)
                            ])),
                      ],
                    ),
                  ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CustomTextField(
                //     controller: searchCont,
                //     hint: "Search any Product",
                //     prefixWidget: Icon(Icons.search),
                //     isEnabled: true,
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: data.searchCont,
                    hint: "Search Products",
                    prefixWidget: const Icon(Icons.search),
                    isEnabled: true,
                    suffixWidget: data.searchCont.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              data.searchCont.clear();
                              callProducts = data.prod!;
                              setState(() {});
                            },
                            child: const Icon(Icons.close))
                        : const SizedBox.shrink(),
                    onChange: productSearchFunction,
                  ),
                ),

                if (callProducts.isNotEmpty)
                  Wrap(
                    children: [
                      for (var product in callProducts)
                        SalesrepProductsWidget(
                          customerName: widget.customerName!,
                          productData: product,
                          customerId: widget.customerId,
                          isShowCartBtn: widget.isReseller,
                          email: widget.email,
                          phone: widget.phone,
                        )
                    ],
                  )
                else if (callProducts.isEmpty &&
                    data.searchCont.text.isNotEmpty)
                  const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Product not Found',
                          style: titleStyle,
                        ),
                      ))

                //
                // showSearch == false
                //     ? Consumer<ProductsProvider>(builder: (context, product, _) {
                //         List<Widget> widgets = [];
                //         product.prod!.isNotEmpty
                //             ? product.prod!.forEach((element) {
                //                 widgets.add(SalesrepProductsWidget(
                //                   productData: element,
                //                   customerId: widget.customerId,
                //                   isShowCartBtn: widget.isReseller,
                //                 ));
                //               })
                //             : Container(
                //                 alignment: Alignment.center,
                //                 child: const Text(
                //                   "No Product Available",
                //                 ),
                //               );
                //         return Center(
                //           child: Wrap(
                //             alignment: WrapAlignment.start,
                //             crossAxisAlignment: WrapCrossAlignment.center,
                //             children: widgets,
                //           ),
                //         );
                //       })
                //     : Consumer<ProductSearchProvider>(builder: (context, prod, _) {
                //         List<Widget> widgets = [];
                //         prod.prodSearch!.isNotEmpty && prod.prodSearch != null
                //             ? prod.prodSearch!.forEach((element) {
                //                 widgets.add(SalesrepProductsWidget(
                //                   productData: element,
                //                   customerId: widget.customerId,
                //                   isShowCartBtn: widget.isReseller,
                //                 ));
                //               })
                //             : Container(
                //                 alignment: Alignment.center,
                //                 child: const Text(
                //                   "No Product Available",
                //                 ),
                //               );
                //         return Center(
                //           child: Wrap(
                //             alignment: WrapAlignment.start,
                //             crossAxisAlignment: WrapCrossAlignment.center,
                //             children: widgets,
                //           ),
                //         );
                //       }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
