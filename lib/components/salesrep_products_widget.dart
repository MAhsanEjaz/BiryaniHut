import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/screens/product_details/components/product_description.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/sales%20rep/salesrep_cart_page.dart';
import 'package:shop_app/storages/salesrep_cart_storage.dart';

import '../customer/screens/product_details/salesrep_product_details.dart';
import '../providers/counter_provider.dart';
import '../providers/products_provider.dart';
import '../size_config.dart';

class SalesrepProductsWidget extends StatefulWidget {
  ProductData productData;
  int customerId;
  String customerName;
  bool isShowCartBtn;
  String email, phone;

  SalesrepProductsWidget(
      {Key? key,
      required this.productData,
      required this.customerId,
      required this.customerName,
      required this.email,
      required this.phone,
      required this.isShowCartBtn})
      : super(key: key);

  @override
  State<SalesrepProductsWidget> createState() => _SalesrepProductsWidgetState();
}

class _SalesrepProductsWidgetState extends State<SalesrepProductsWidget> {
  SalesrepCartStorage cartStorage = SalesrepCartStorage();

  TextEditingController quantityCont = TextEditingController();
  FocusNode quantityNode = FocusNode();

  // TextEditingController updateControl = TextEditingController();
  List<String> list = [];
  List<CartItem> model = [];
  num totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // quantityCont;
    getCartItems();
    calculateQuantity();
    // quantityCont.text = qty.toString();
    quantityCont = TextEditingController();
  }

  bool showMoreQty = false;

  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
//! navigate to cart page in rep side
//! in customer side on click will take it to product detail page
            if (widget.customerId == 0) {
            } else {
              Provider.of<ProductsProvider>(context, listen: false)
                  .clearProductsSearchCont();
              Focus.of(context).requestFocus(FocusNode());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesRepCartPage(
                      customerId: widget.customerId,
                      customerName: widget.customerName,
                      email: widget.email,
                      phone: widget.phone,
                    ),
                  ));
            }

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => SalesrepProductDetailsPage(
            //         isShowCartBtn: widget.isShowCartBtn,
            //         data: widget.productData,
            //         customerId: widget.customerId,
            //       ),
            //     ));

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ProductDetailsPage(
            //         isShowCartBtn: widget.isShowCartBtn,
            //         isRep: true,
            //         data: widget.productData,
            //         customerId: widget.customerId,
            //       ),
            //     ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        height: 220,
                        width: MediaQuery.of(context).size.width / 2.2,
                        imageUrl: widget.productData.productImagePath == "" ||
                                widget.productData.productImagePath == null
                            ? dummyImageUrl
                            : widget.productData.productImagePath!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              // colorFilter: const ColorFilter.mode(
                              //     Colors.black12, BlendMode.dstOut)
                            ),
                          ),
                        ),
                        placeholder: (context, url) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesRepCartPage(
                                    customerId: widget.customerId,
                                    customerName: widget.customerName,
                                    email: widget.email,
                                    phone: widget.phone,
                                  ),
                                ));
                          },
                          child: SizedBox(
                            height: 220,
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: appColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.productData.productName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                width: 100,
                              ),
                              const SizedBox(width: 30),
                              if (widget.isShowCartBtn)
                                Builder(builder: (context) {
                                  return InkWell(
                                    onTap: () {
                                      // model.clear();

                                      if (quantityCont.text.isEmpty) {
                                        quantityCont.text = "1";
                                      }

                                      totalPrice = 0;
                                      getCartItems();
                                      int quantity =
                                          int.parse(quantityCont.text);

                                      if (quantity > 10000) {
                                        showToast("Please Add Valid Quantity");
                                        return;
                                      }

                                      // if (quantityCont.text.isEmpty) {
                                      //   showToast("Please add some quantity");
                                      //   return;
                                      // }

                                      /// check if the string contains only numberscar

                                      else if (!isNumeric(quantityCont.text)) {
                                        showToast("Quantity not valid");
                                        return;
                                      } else if (quantity < 1) {
                                        showToast(
                                            "Quantity can't be less than 1");
                                        return;
                                      }

                                      List<CartItem> model = [];

                                      bool isDuplicate = false;

                                      if (cartStorage.getCartItems(
                                              customerId: widget.customerId) !=
                                          null) {
                                        var list = cartStorage.getCartItems(
                                            customerId: widget.customerId);
                                        // log("listlist = $list");

                                        list!.forEach((element) {
                                          model.add(CartItem.fromJson(
                                              json.decode(element)));
                                        });
                                        log("model length = ${model.length}");

                                        model.forEach((element) {
                                          if (element.productId ==
                                              widget.productData.productId) {
                                            isDuplicate = true;
                                            //! add previous items and new items
                                            element.quantity =
                                                element.quantity + quantity;
                                            cartStorage.updateCartItem(
                                                item: element,
                                                customerId: widget.customerId);
                                          }
                                        });

                                        if (isDuplicate) {
                                          showToast("Cart Items Updated");
                                        } else {
                                          showToast("Added to Cart");

                                          addtoCart(
                                            widget.productData,
                                            context,
                                            quantity,
                                          );
                                        }
                                      } else {
                                        showToast("Added to Cart");

                                        addtoCart(widget.productData, context,
                                            quantity);
                                      }
                                      quantityCont.clear();
                                      //! was showing quantity with any other product add to cart in search
                                      //! so, i cleared it add to cart time.
                                      quantityNode.unfocus();
                                      Provider.of<ProductsProvider>(context,
                                              listen: false)
                                          .clearProductsSearchCont();
                                      if (mounted) {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    SalesRepCartPage(
                                                      customerId:
                                                          widget.customerId,
                                                      customerName:
                                                          widget.customerName,
                                                      email: widget.email,
                                                      phone: widget.phone,
                                                    )));
                                      }
                                    },
                                    child: Card(
                                        color: appColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        )),
                                  );
                                })
                            ],
                          ))
                    ],
                  ),
                ],
              ),
              // Container(
              //   height: 220,
              //   width: MediaQuery.of(context).size.width / 2.2,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: NetworkImage(
              //             widget.productData.productImagePath == "" ||
              //                     widget.productData.productImagePath == null
              //                 ? dummyImageUrl
              //                 : widget.productData.productImagePath!,
              //           ),
              //           onError: (exception, stackTrace) => const SizedBox(),
              //           fit: BoxFit.cover)),
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         gradient: LinearGradient(
              //             colors: [Colors.black26, Colors.white24])),
              //     child: Column(
              //       children: [
              //         const Spacer(),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 8.0, vertical: 8.0),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               SizedBox(
              //                 child: Text(
              //                   widget.productData.productName,
              //                   style: const TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //                 width: 100,
              //               ),
              //               if (widget.isShowCartBtn)
              //                 Builder(builder: (context) {
              //                   return InkWell(
              //                     onTap: () {
              //                       // model.clear();
              //
              //                       totalPrice = 0;
              //                       getCartItems();
              //                       int quantity = int.parse(quantityCont.text);
              //                       if (quantityCont.text.isEmpty) {
              //                         showToast("Please add some quantity");
              //                         return;
              //                       }
              //
              //                       /// check if the string contains only numbers
              //
              //                       else if (!isNumeric(quantityCont.text)) {
              //                         showToast("Quantity not valid");
              //                         return;
              //                       } else if (quantity < 1) {
              //                         showToast(
              //                             "Quantity can't be less than 1");
              //                         return;
              //                       }
              //
              //                       List<CartItem> model = [];
              //
              //                       bool isDuplicate = false;
              //
              //                       if (cartStorage.getCartItems(
              //                               customerId: widget.customerId) !=
              //                           null) {
              //                         var list = cartStorage.getCartItems(
              //                             customerId: widget.customerId);
              //                         // log("listlist = $list");
              //
              //                         list!.forEach((element) {
              //                           model.add(CartItem.fromJson(
              //                               json.decode(element)));
              //                         });
              //                         log("model length = ${model.length}");
              //
              //                         model.forEach((element) {
              //                           if (element.productId ==
              //                               widget.productData.productId) {
              //                             isDuplicate = true;
              //                           }
              //                         });
              //
              //                         if (isDuplicate) {
              //                           showToast("Already Added to Cart");
              //                         } else {
              //                           showToast("Added to Cart");
              //
              //                           addtoCart(
              //                             widget.productData,
              //                             context,
              //                             quantity,
              //                           );
              //                         }
              //                       } else {
              //                         showToast("Added to Cart");
              //
              //                         addtoCart(widget.productData, context,
              //                             quantity);
              //                       }
              //                       quantityNode.unfocus();
              //                       Provider.of<ProductsProvider>(context,
              //                               listen: false)
              //                           .clearProductsSearchCont();
              //                       if (mounted) {
              //                         Navigator.push(
              //                             context,
              //                             CupertinoPageRoute(
              //                                 builder: (context) =>
              //                                     SalesRepCartPage(
              //                                       customerId:
              //                                           widget.customerId,
              //                                       customerName:
              //                                           widget.customerName,
              //                                       email: widget.email,
              //                                       phone: widget.phone,
              //                                     )));
              //                       }
              //                     },
              //                     child: Card(
              //                         color: appColor,
              //                         elevation: 10,
              //                         shape: RoundedRectangleBorder(
              //                             borderRadius:
              //                                 BorderRadius.circular(20.0)),
              //                         child: const Padding(
              //                           padding: EdgeInsets.all(2.0),
              //                           child: Icon(
              //                             Icons.add,
              //                             color: Colors.white,
              //                           ),
              //                         )),
              //                   );
              //                 })
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
        if (widget.isShowCartBtn)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: qty.bitLength < 2
                    ? null
                    : () {
                        setState(() {
                          qty--;
                          quantityCont.text = qty.toString();
                        });
                      },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      CupertinoIcons.minus,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  color: appColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      // borderRadius: BorderRadius.circular(2),
                      ),
                  child: Center(
                    child: TextField(
                      focusNode: quantityNode,
                      keyboardType: TextInputType.number,
                      // maxLength: 7,
                      controller: quantityCont,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "1",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4),
                      ),
                      onChanged: (value) {
                        setState(() {
                          qty = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    qty++;
                    quantityCont.text = qty.toString();
                  });
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: appColor,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }

  // void decrementQuantity() {
  //   for (var element in model) {
  //     if (element.productId == widget.productData.productId) {
  //       element.quantity--;
  //       qty = element.quantity;
  //       break;
  //     }
  //   }
  //   setState(() {});
  // }
  //
  // void incrementQuantity() {
  //   for (var element in model) {
  //     if (element.productId == widget.productData.productId) {
  //       element.quantity++;
  //       qty = element.quantity;
  //       break;
  //     }
  //   }
  //   setState(() {});
  // }

  void calculateQuantity() {
    for (var element in model) {
      if (element.productId == widget.productData.productId) {
        qty = element.quantity;
        break;
      }
    }
  }

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  void addtoCart(ProductData item, BuildContext context, int quantity) {
// int quantity = 0;
    Provider.of<ProductsProvider>(context, listen: false)
        .clearProductsSearchCont();
    CartItem cartItem = CartItem(
      productId: item.productId,
      price: item.salePrice,
      quantity: quantity,
      discount: item.discount,
      productDescription: item.discription,
      productImage: item.productImagePath!,
      productImagePath: item.productImagePath!,
      productName: item.productName,
      totalCost: item.salePrice * quantity,
      totalPrice: item.salePrice,
    );
    cartStorage.addCartItem(item: cartItem, customerId: widget.customerId);
    Provider.of<CartCounterProvider>(context, listen: false).incrementCount();
  }

  void getCartItems() {
    if (cartStorage.getCartItems(customerId: widget.customerId) != null) {
      list = cartStorage.getCartItems(customerId: widget.customerId)!;
      // log("listlist = $list");
      list.forEach((element) {
        model.add(CartItem.fromJson(json.decode(element)));
      });

      model.forEach((element) {
        totalPrice = totalPrice + element.price * element.quantity;
      });
    }
  }
}

class RowWithImage extends StatefulWidget {
  final String image;
  final String name;

  const RowWithImage({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  State<RowWithImage> createState() => _RowWithImageState();
}

class _RowWithImageState extends State<RowWithImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 10),
            SizedBox(
                width: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.toString(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
