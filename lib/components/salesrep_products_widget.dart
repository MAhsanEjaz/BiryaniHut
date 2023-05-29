import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/components/rounded_icon_btn.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/screens/product_details/customer_product_detail_page.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/storages/salesrep_cart_storage.dart';

import '../customer/screens/product_details/salesrep_product_details.dart';
import '../providers/counter_provider.dart';
import '../size_config.dart';

class SalesrepProductsWidget extends StatefulWidget {
  ProductData productData;
  int customerId;
  bool isShowCartBtn;

  SalesrepProductsWidget(
      {Key? key,
      required this.productData,
      required this.customerId,
      required this.isShowCartBtn})
      : super(key: key);

  @override
  State<SalesrepProductsWidget> createState() => _SalesrepProductsWidgetState();
}

class _SalesrepProductsWidgetState extends State<SalesrepProductsWidget> {
  SalesrepCartStorage cartStorage = SalesrepCartStorage();

  TextEditingController quantityCont = TextEditingController();
  TextEditingController updateControl = TextEditingController();
  List<String> list = [];
  List<CartItem> model = [];
  num totalPrice = 0;

  // quantityFunction() async {
  //   for (int i = 0; i < model.length; i++) {
  //     updateControl.text = model[i].quantity.toString();
  //     print(updateControl.text);
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // quantityCont;
    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //SalesrepProductDetailsPage

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesrepProductDetailsPage(
                isShowCartBtn: widget.isShowCartBtn,
                data: widget.productData,
                customerId: widget.customerId,
              ),
            ));

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
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width / 2.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        widget.productData.productImagePath == "" ||
                                widget.productData.productImagePath == null
                            ? dummyImageUrl
                            : getImageUrl(
                                widget.productData.productImagePath!,
                              )),
                    onError: (exception, stackTrace) => const SizedBox(),
                    fit: BoxFit.cover)),
            child: Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.black26, Colors.white24])),
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(
                            widget.productData.productName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          width: 100,
                        ),
                        if (widget.isShowCartBtn)
                          InkWell(
                            onTap: () {
                              model.clear();
                              totalPrice = 0;
                              getCartItems();
                              showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                          builder: (context, setStateFirst) {
                                        return CupertinoAlertDialog(
                                            // title: const Text(
                                            //     'Add product quantity'),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  )),
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    int quantity = int.parse(
                                                        quantityCont.text);
                                                    if (quantityCont
                                                        .text.isEmpty) {
                                                      showToast(
                                                          "Please add some quantity");
                                                      return;
                                                    }

                                                    /// check if the string contains only numbers

                                                    else if (!isNumeric(
                                                        quantityCont.text)) {
                                                      showToast(
                                                          "Quantity not valid");
                                                      return;
                                                    } else if (quantity < 1) {
                                                      showToast(
                                                          "Quantity can't be less than 1");
                                                      return;
                                                    }

                                                    Navigator.pop(context);

                                                    List<CartItem> model = [];

                                                    bool isDuplicate = false;

                                                    if (cartStorage.getCartItems(
                                                            customerId: widget
                                                                .customerId) !=
                                                        null) {
                                                      var list = cartStorage
                                                          .getCartItems(
                                                              customerId: widget
                                                                  .customerId);
                                                      log("listlist = $list");

                                                      list!.forEach((element) {
                                                        model.add(
                                                            CartItem.fromJson(
                                                                json.decode(
                                                                    element)));
                                                      });
                                                      log("model length = ${model.length}");

                                                      model.forEach((element) {
                                                        if (element.productId ==
                                                            widget.productData
                                                                .productId) {
                                                          isDuplicate = true;
                                                        }
                                                      });

                                                      if (isDuplicate) {
                                                        showToast(
                                                            "Already Added to Cart");
                                                      } else {
                                                        showToast(
                                                            "Added to Cart");

                                                        addtoCart(
                                                          widget.productData,
                                                          context,
                                                          quantity,
                                                        );
                                                      }
                                                    } else {
                                                      showToast(
                                                          "Added to Cart");

                                                      addtoCart(
                                                          widget.productData,
                                                          context,
                                                          quantity);
                                                    }
                                                    quantityCont.clear();
                                                  },
                                                  child: const Text(
                                                    'Ok',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  )),
                                            ],
                                            content: SizedBox(
                                              // width: SizeConfig.screenWidth,
                                              height: model.isEmpty
                                                  ? 160
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                              // Set the height based on the screen size

                                              child: SingleChildScrollView(
                                                child: Column(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (model.isNotEmpty)
                                                      Center(
                                                        child: Text(
                                                          "Total Price = \$${totalPrice.toStringAsFixed(2)}",
                                                          style: titleStyle,
                                                        ),
                                                      ),
                                                    if (model.isNotEmpty)
                                                      const Divider(
                                                        height: 4,
                                                        indent: 2,
                                                      ),
                                                    if (model.isNotEmpty)
                                                      const Text("Cart Items",
                                                          style: titleStyle),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemCount: model.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // final item = model[index];
                                                        // int quantity = item.quantity;
                                                        // model[index].quantity=;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            updateControl.text =
                                                                model[index]
                                                                    .quantity
                                                                    .toString();

                                                            // Navigator.pop(
                                                            //     context);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    StatefulBuilder(builder:
                                                                        (context,
                                                                            setStateSecond) {
                                                                      return CupertinoAlertDialog(
                                                                        actions: [
                                                                          CupertinoActionSheetAction(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                num price = model[index].price * model[index].quantity;

                                                                                totalPrice = totalPrice - price;
                                                                                model.removeAt(index);

                                                                                cartStorage.deleteCartItem(index: index, customerId: widget.customerId);
                                                                                Provider.of<CartCounterProvider>(context, listen: false).setCount(model.length);

                                                                                model.clear();
                                                                                totalPrice = 0;
                                                                                getCartItems();
                                                                                setStateFirst;
                                                                                CustomSnackBar.showSnackBar(context: context, message: "Cart Item Deleted Successfully");
                                                                              },
                                                                              child: const Text(
                                                                                'Delete',
                                                                                style: TextStyle(color: Colors.red, fontSize: 15),
                                                                              )),
                                                                          CupertinoActionSheetAction(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                model[index].quantity = int.parse(updateControl.text);
                                                                                cartStorage.updateCartItem(item: model[index], customerId: widget.customerId);
                                                                                CustomSnackBar.showSnackBar(context: context, message: "Cart Item Updated Successfully");
                                                                                setStateFirst;
                                                                                // model[index].quantity = int.parse(updateControl.text);
                                                                              },
                                                                              child: const Text(
                                                                                'Update',
                                                                                style: TextStyle(color: Colors.green, fontSize: 15),
                                                                              )),
                                                                        ],
                                                                        title:
                                                                            Row(
                                                                          children: [
                                                                            const Text('Update Cart Item'),
                                                                            const Spacer(),
                                                                            GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Card(
                                                                                  elevation: 10,
                                                                                  child: Icon(Icons.close),
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        content:
                                                                            Column(
                                                                          children: [
                                                                            const SizedBox(height: 20),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 40,
                                                                                  child: AspectRatio(
                                                                                    aspectRatio: 0.88,
                                                                                    child: Container(
                                                                                      // padding: EdgeInsets.all(
                                                                                      //     getProportionateScreenWidth(
                                                                                      //         10)),
                                                                                      decoration: BoxDecoration(
                                                                                        color: const Color(0xFFF5F6F9),
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                      // child: Image.network(cart.product.images[0]),
                                                                                      child: Image.network(model[index].productImagePath == "" ||
                                                                                              // ignore: unnecessary_null_comparison
                                                                                              model[index].productImagePath == null
                                                                                          ? dummyImageUrl
                                                                                          : getImageUrl(model[index].productImagePath)),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 10),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: SizeConfig.screenWidth * .5,
                                                                                      child: Text(
                                                                                        model[index].productName,
                                                                                        // overflow:
                                                                                        //     TextOverflow
                                                                                        //         .ellipsis,
                                                                                        softWrap: true,
                                                                                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        maxLines: 2,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(height: 10),
                                                                                    Text.rich(
                                                                                      TextSpan(
                                                                                        text: "\$${model[index].price}",
                                                                                        style: const TextStyle(fontWeight: FontWeight.w400, color: kPrimaryColor),
                                                                                        children: [
                                                                                          TextSpan(
                                                                                              // text: " x${cart.numOfItem}",
                                                                                              text: " x ${model[index].quantity}",
                                                                                              style: Theme.of(context).textTheme.bodyText1),
                                                                                          TextSpan(
                                                                                              // text: " x${cart.numOfItem}",
                                                                                              text: " = \$" + (model[index].price * model[index].quantity).toStringAsFixed(2),
                                                                                              style: Theme.of(context).textTheme.bodyText1),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    // Row(
                                                                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                                                                    //   children: [
                                                                                    //     RoundedIconBtn(
                                                                                    //       icon: Icons.remove,
                                                                                    //       showShadow: true,
                                                                                    //       press: () {
                                                                                    //         totalPrice = totalPrice -
                                                                                    //             model[index].price *
                                                                                    //                 model[index].quantity;

                                                                                    //         model[index].quantity--;
                                                                                    //         //! if quantity is less than 1 then remove item from cart
                                                                                    //         if (model[index].quantity < 1) {
                                                                                    //           cartStorage.deleteCartItem(
                                                                                    //               index: index,
                                                                                    //               customerId: widget.customerId);
                                                                                    //           model.removeAt(index);
                                                                                    //           Provider.of<CartCounterProvider>(
                                                                                    //                   context,
                                                                                    //                   listen: false)
                                                                                    //               .decrementCount();
                                                                                    //         } else {
                                                                                    //           totalPrice = totalPrice +
                                                                                    //               model[index].price *
                                                                                    //                   model[index].quantity;

                                                                                    //           cartStorage.updateCartItem(
                                                                                    //               item: model[index],
                                                                                    //               customerId: widget.customerId);
                                                                                    //         }

                                                                                    //         // updatePrices();
                                                                                    //         setStatesss(() {});
                                                                                    //       },
                                                                                    //     ),
                                                                                    //     SizedBox(
                                                                                    //         width:
                                                                                    //             getProportionateScreenWidth(20)),
                                                                                    //     RoundedIconBtn(
                                                                                    //       icon: Icons.add,
                                                                                    //       showShadow: true,
                                                                                    //       press: () {
                                                                                    //         totalPrice = totalPrice -
                                                                                    //             model[index].price *
                                                                                    //                 model[index].quantity;

                                                                                    //         model[index].quantity++;
                                                                                    //         cartStorage.updateCartItem(
                                                                                    //             item: model[index],
                                                                                    //             customerId: widget.customerId);

                                                                                    //         totalPrice = totalPrice +
                                                                                    //             model[index].price *
                                                                                    //                 model[index].quantity;
                                                                                    //         // updatePrices();

                                                                                    //         setState(() {});

                                                                                    //         log("quantity = ${model[index].quantity}");
                                                                                    //       },
                                                                                    //     ),
                                                                                    //   ],
                                                                                    // )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10),
                                                                            CupertinoTextField(
                                                                              placeholder: 'Enter Quantity',
                                                                              controller: updateControl,
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 40,
                                                                  child:
                                                                      AspectRatio(
                                                                    aspectRatio:
                                                                        0.88,
                                                                    child:
                                                                        Container(
                                                                      // padding: EdgeInsets.all(
                                                                      //     getProportionateScreenWidth(
                                                                      //         10)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFFF5F6F9),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      // child: Image.network(cart.product.images[0]),
                                                                      child: Image.network(model[index].productImagePath == "" ||
                                                                              // ignore: unnecessary_null_comparison
                                                                              model[index].productImagePath == null
                                                                          ? dummyImageUrl
                                                                          : getImageUrl(model[index].productImagePath)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          SizeConfig.screenWidth *
                                                                              .5,
                                                                      child:
                                                                          Text(
                                                                        model[index]
                                                                            .productName,
                                                                        // overflow:
                                                                        //     TextOverflow
                                                                        //         .ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        maxLines:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text.rich(
                                                                      TextSpan(
                                                                        text:
                                                                            "\$${model[index].price}",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: kPrimaryColor),
                                                                        children: [
                                                                          TextSpan(
                                                                              // text: " x${cart.numOfItem}",
                                                                              text: " x ${model[index].quantity}",
                                                                              style: Theme.of(context).textTheme.bodyText1),
                                                                          TextSpan(
                                                                              // text: " x${cart.numOfItem}",
                                                                              text: " = \$" + (model[index].price * model[index].quantity).toStringAsFixed(2),
                                                                              style: Theme.of(context).textTheme.bodyText1),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    // Row(
                                                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                                                    //   children: [
                                                                    //     RoundedIconBtn(
                                                                    //       icon: Icons.remove,
                                                                    //       showShadow: true,
                                                                    //       press: () {
                                                                    //         totalPrice = totalPrice -
                                                                    //             model[index].price *
                                                                    //                 model[index].quantity;

                                                                    //         model[index].quantity--;
                                                                    //         //! if quantity is less than 1 then remove item from cart
                                                                    //         if (model[index].quantity < 1) {
                                                                    //           cartStorage.deleteCartItem(
                                                                    //               index: index,
                                                                    //               customerId: widget.customerId);
                                                                    //           model.removeAt(index);
                                                                    //           Provider.of<CartCounterProvider>(
                                                                    //                   context,
                                                                    //                   listen: false)
                                                                    //               .decrementCount();
                                                                    //         } else {
                                                                    //           totalPrice = totalPrice +
                                                                    //               model[index].price *
                                                                    //                   model[index].quantity;

                                                                    //           cartStorage.updateCartItem(
                                                                    //               item: model[index],
                                                                    //               customerId: widget.customerId);
                                                                    //         }

                                                                    //         // updatePrices();
                                                                    //         setStatesss(() {});
                                                                    //       },
                                                                    //     ),
                                                                    //     SizedBox(
                                                                    //         width:
                                                                    //             getProportionateScreenWidth(20)),
                                                                    //     RoundedIconBtn(
                                                                    //       icon: Icons.add,
                                                                    //       showShadow: true,
                                                                    //       press: () {
                                                                    //         totalPrice = totalPrice -
                                                                    //             model[index].price *
                                                                    //                 model[index].quantity;

                                                                    //         model[index].quantity++;
                                                                    //         cartStorage.updateCartItem(
                                                                    //             item: model[index],
                                                                    //             customerId: widget.customerId);

                                                                    //         totalPrice = totalPrice +
                                                                    //             model[index].price *
                                                                    //                 model[index].quantity;
                                                                    //         // updatePrices();

                                                                    //         setState(() {});

                                                                    //         log("quantity = ${model[index].quantity}");
                                                                    //       },
                                                                    //     ),
                                                                    //   ],
                                                                    // )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    if (model.isNotEmpty)
                                                      const Divider(
                                                        height: 4,
                                                        indent: 2,
                                                      ),
                                                    const Text("Add Quantity",
                                                        style: titleStyle),
                                                    RowWithImage(
                                                        image: getImageUrl(
                                                          widget.productData
                                                              .productImagePath!,
                                                        ),
                                                        name: widget.productData
                                                            .productName),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                        '\$${widget.productData.price.toString()}'),
                                                    const SizedBox(height: 10),
                                                    CupertinoTextField(
                                                      placeholder:
                                                          'Enter Quantity',
                                                      controller: quantityCont,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black12)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      }));
                            },
                            child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black54,
                                  ),
                                )),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  void addtoCart(ProductData item, BuildContext context, int quantity) {
// int quantity = 0;

    CartItem cartItem = CartItem(
      productId: item.productId,
      price: item.price,
      quantity: quantity,
      discount: item.discount,
      productDescription: item.discription,
      productImage: item.productImagePath!,
      productImagePath: item.productImagePath!,
      productName: item.productName,
      totalCost: item.price * item.quantity,
      totalPrice: item.price,
    );
    cartStorage.addCartItem(item: cartItem, customerId: widget.customerId);
    Provider.of<CartCounterProvider>(context, listen: false).incrementCount();
  }

  void getCartItems() {
    if (cartStorage.getCartItems(customerId: widget.customerId) != null) {
      list = cartStorage.getCartItems(customerId: widget.customerId)!;
      log("listlist = $list");
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
  String? image;
  String? name;

  RowWithImage({Key? key, required this.image, required this.name})
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
                      image: NetworkImage(widget.image!), fit: BoxFit.cover),
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
