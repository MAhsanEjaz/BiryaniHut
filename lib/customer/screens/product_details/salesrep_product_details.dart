import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/screens/product_details/components/product_description.dart';
import 'package:shop_app/customer/screens/product_details/components/product_images.dart';
import 'package:shop_app/customer/screens/product_details/components/top_rounded_container.dart';
import 'package:shop_app/helper/custom_snackbar.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/providers/counter_provider.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/storages/customer_cart_storage.dart';
import 'package:shop_app/storages/salesrep_cart_storage.dart';
import '../../../components/common_widgets.dart';
import '../../../components/salesrep_products_widget.dart';
import '../../../models/cart_model.dart';
import 'components/custom_app_bar.dart';

class SalesrepProductDetailsPage extends StatefulWidget {
  final bool isShowCartBtn;
  final int customerId;
  final ProductData data;

  const SalesrepProductDetailsPage(
      {Key? key,
      required this.isShowCartBtn,
      required this.data,
      required this.customerId})
      : super(key: key);

  @override
  State<SalesrepProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<SalesrepProductDetailsPage> {
  // CustomerCartStorage customerCartStorage = CustomerCartStorage();
  SalesrepCartStorage cartStorage = SalesrepCartStorage();
  List<String> list = [];
  List<CartItem> model = [];
  final quantityCont = TextEditingController();
  num totalPrice = 0;
  @override
  void initState() {
    super.initState();
    getCartItems();
    log("isShowCartBtn = ${widget.isShowCartBtn}");
  }

  TextEditingController updateControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(rating: 4),
        ),
        body: ListView(
          children: [
            ProductImages(product: widget.data),
            TopRoundedContainer(
              color: Colors.white,
              child: Column(
                children: [
                  ProductDescription(
                    isReseller: true,
                    product: widget.data,
                    pressOnSeeMore: () {},
                  ),
                  // if (widget.isShowCartBtn)
                  TopRoundedContainer(
                    color: const Color(0xFFF6F7F9),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20)),
                          child: Row(
                            children: [
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text:
                                      "\$ ${widget.data.salePrice.toString()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: kPrimaryColor),
                                  // children: [
                                  // TextSpan(
                                  //     text: "* 3", style: Theme.of(context).textTheme.bodyText1),
                                  // ],
                                ),
                              ),
                              // const Spacer(),
                              // RoundedIconBtn(
                              //   icon: Icons.remove,
                              //   press: () {},
                              // ),
                              // SizedBox(
                              //     width: getProportionateScreenWidth(20)),
                              // RoundedIconBtn(
                              //   icon: Icons.add,
                              //   showShadow: true,
                              //   press: () {},
                              // ),
                            ],
                          ),
                        ),
                        if (widget.isShowCartBtn)
                          TopRoundedContainer(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                bottom: getProportionateScreenWidth(40),
                                top: getProportionateScreenWidth(15),
                              ),
                              child: DefaultButton(
                                text: "Add To Cart",
                                press: () {
                                  model.clear();
                                  totalPrice = 0;
                                  getCartItems();
                                  showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                              builder: (context, setStatesss) {
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
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      )),
                                                  CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        int quantity =
                                                            int.parse(
                                                                quantityCont
                                                                    .text);
                                                        if (quantityCont
                                                            .text.isEmpty) {
                                                          showToast(
                                                              "Please add some quantity");
                                                          return;
                                                        }

                                                        /// check if the string contains only numbers

                                                        else if (!isNumeric(
                                                            quantityCont
                                                                .text)) {
                                                          showToast(
                                                              "Quantity not valid");
                                                          return;
                                                        } else if (quantity <
                                                            1) {
                                                          showToast(
                                                              "Quantity can't be less than 1");
                                                          return;
                                                        }
                                                        // else if (widget
                                                        //         .data.quantity <
                                                        //     quantity) {
                                                        //   showToast(
                                                        //       "You can add upto ${widget.data.quantity} items only");
                                                        //   return;
                                                        // }
                                                        // log("item.quantity = ${widget.data.quantity}");
                                                        // log("quantity = $quantity");

                                                        // if (widget
                                                        //         .data.quantity <
                                                        //     quantity) {
                                                        //   showToast(
                                                        //       "You can add upto ${widget.data.quantity} items only");
                                                        //   return;
                                                        // }
                                                        Navigator.pop(context);

                                                        List<CartItem> model =
                                                            [];

                                                        bool isDuplicate =
                                                            false;

                                                        if (cartStorage.getCartItems(
                                                                customerId: widget
                                                                    .customerId) !=
                                                            null) {
                                                          var list = cartStorage
                                                              .getCartItems(
                                                                  customerId: widget
                                                                      .customerId);
                                                          log("listlist = $list");

                                                          list!.forEach(
                                                              (element) {
                                                            model.add(CartItem
                                                                .fromJson(
                                                                    json.decode(
                                                                        element)));
                                                          });
                                                          log("model length = ${model.length}");

                                                          model.forEach(
                                                              (element) {
                                                            if (element
                                                                    .productId ==
                                                                widget.data
                                                                    .productId) {
                                                              isDuplicate =
                                                                  true;
                                                            }
                                                          });

                                                          if (isDuplicate) {
                                                            showToast(
                                                                "Already Added to Cart");
                                                          } else {
                                                            showToast(
                                                                "Added to Cart");

                                                            addtoCart(
                                                              widget.data,
                                                              context,
                                                              int.parse(
                                                                  quantityCont
                                                                      .text),
                                                            );
                                                          }
                                                        } else {
                                                          showToast(
                                                              "Added to Cart");

                                                          addtoCart(
                                                            widget.data,
                                                            context,
                                                            int.parse(
                                                                quantityCont
                                                                    .text),
                                                          );
                                                        }
                                                        quantityCont.clear();
                                                      },
                                                      child: const Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                            fontSize: 15),
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                          const Text(
                                                              "Cart Items",
                                                              style:
                                                                  titleStyle),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          itemCount:
                                                              model.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            // final item = model[index];
                                                            // int quantity = item.quantity;
                                                            // model[index].quantity=;
                                                            return GestureDetector(
                                                              onTap: () {
                                                                updateControl
                                                                    .text = model[
                                                                        index]
                                                                    .quantity
                                                                    .toString();

                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (context) =>
                                                                        StatefulBuilder(builder:
                                                                            (context,
                                                                                setStatesss) {
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
                                                                padding: const EdgeInsets
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
                                                                            color:
                                                                                const Color(0xFFF5F6F9),
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
                                                                        width:
                                                                            10),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              SizeConfig.screenWidth * .5,
                                                                          child:
                                                                              Text(
                                                                            model[index].productName,
                                                                            // overflow:
                                                                            //     TextOverflow
                                                                            //         .ellipsis,
                                                                            softWrap:
                                                                                true,
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold),
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
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w400, color: kPrimaryColor),
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
                                                        const Text(
                                                            "Add Quantity",
                                                            style: titleStyle),
                                                        RowWithImage(
                                                            image: getImageUrl(
                                                              widget.data
                                                                  .productImagePath!,
                                                            ),
                                                            name: widget.data
                                                                .productName),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                            '\$${widget.data.salePrice.toString()}'),
                                                        const SizedBox(
                                                            height: 10),
                                                        CupertinoTextField(
                                                          placeholder:
                                                              'Enter Quantity',
                                                          controller:
                                                              quantityCont,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
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

                                  // List<ProductData> model = [];

                                  // bool isDuplicate = false;
                                  // // if (widget.isRep) {
                                  // if (salesrepCartStorage.getCartItems(
                                  //         customerId: widget.customerId) !=
                                  //     null) {
                                  //   var list = salesrepCartStorage.getCartItems(
                                  //       customerId: widget.customerId);
                                  //   log("listlist = $list");

                                  //   list!.forEach((element) {
                                  //     model.add(ProductData.fromJson(
                                  //         json.decode(element)));
                                  //   });
                                  //   log("model length = ${model.length}");

                                  //   model.forEach((element) {
                                  //     if (element.productId ==
                                  //         widget.data.productId) {
                                  //       isDuplicate = true;
                                  //       return;
                                  //     }
                                  //   });
                                  //   log("product detail page");
                                  //   log("isDuplicate value = $isDuplicate");

                                  //   if (isDuplicate) {
                                  //     showToast("Already Added to Cart");
                                  //   } else {
                                  //     showToast("Added to cart");

                                  //     addtoCart(widget.data);
                                  //   }
                                  // } else {
                                  //   showToast("Added to cart");

                                  //   addtoCart(widget.data);
                                  // }

                                  // } else {
                                  //   if (customerCartStorage.getCartItems() !=
                                  //       null) {
                                  //     var list =
                                  //         customerCartStorage.getCartItems();
                                  //     log("listlist = $list");

                                  //     list!.forEach((element) {
                                  //       model.add(ProductData.fromJson(
                                  //           json.decode(element)));
                                  //     });
                                  //     log("model length = ${model.length}");

                                  //     model.forEach((element) {
                                  //       if (element.productId ==
                                  //           widget.data.productId) {
                                  //         isDuplicate = true;
                                  //       }
                                  //     });

                                  //     if (isDuplicate) {
                                  //       showToast("Already Added to Cart");
                                  //     } else {
                                  //       showToast("Added to cart");

                                  //       addtoCart(widget.data);
                                  //     }
                                  //   } else {
                                  //     showToast("Added to cart");

                                  //     addtoCart(widget.data);
                                  //   }
                                  // }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
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

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  void addtoCart(ProductData item, BuildContext context, int quantity) {
// int quantity = 0;

    CartItem cartItem = CartItem(
        discount: item.discount,
        price: item.salePrice,
        productDescription: item.discription,
        productId: item.productId,
        productImage: item.productImagePath!,
        productImagePath: item.productImagePath!,
        productName: item.productName,
        quantity: quantity,
        totalCost: item.salePrice * item.quantity,
        totalPrice: item.salePrice);

    // if (widget.isRep) {
    cartStorage.addCartItem(item: cartItem, customerId: widget.customerId);
    Provider.of<CartCounterProvider>(context, listen: false).incrementCount();
    // }
    // else {
    //   customerCartStorage.addCartItem(item: cartItem);
    //   Provider.of<CartCounterProvider>(context, listen: false).incrementCount();
    // }
  }
}

class ProductDetailsArguments {
  final ProductData product;

  ProductDetailsArguments({required this.product});
}
