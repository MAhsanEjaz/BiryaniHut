// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shop_app/customer/models/pdf_view_model.dart';
// import 'package:shop_app/customer/models/products_model.dart';
// import 'package:shop_app/customer/screens/cart/components/payment_methods.dart';
// import 'package:shop_app/customer/screens/home/components/price_textFiled.dart';
// import 'package:shop_app/services/pdf_invoice_services.dart';

// import '../../../components/default_button.dart';
// import '../../../components/rounded_icon_btn.dart';
// import '../../../constants.dart';
// import '../../../size_config.dart';
// import '../../../storages/customer_cart_storage.dart';
// import 'components/cart_card.dart';
// import 'components/check_out_card.dart';
// import 'components/pdf_service.dart';

// class CartPage extends StatefulWidget {
//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   int selectedIndex = 0;
//   List<ProductData> model = [];
//   num totalDiscount = 0;
//   num totalPrice = 0;
//   num grandTotal = 0;
//   List<num> pricelist = [];
//   List<num> discountlist = [];
//   CartStorage cartStorage = CartStorage();

//   @override
//   void initState() {
//     if (cartStorage.getCartItems() != null) {
//       var list = cartStorage.getCartItems();
//       log("listlist = $list");
//       list!.forEach((element) {
//         model.add(ProductData.fromJson(json.decode(element)));
//       });
//       log("model length = ${model.length}");
//     }

//     //! calculate initial values
//     model.forEach((element) {
//       totalDiscount = totalDiscount + element.discount * element.quantity;
//       totalPrice = totalPrice + element.price * element.quantity;
//       log("totalPrice /// = $totalPrice");
//     });
//     super.initState();
//   }

//   PdfViewModel? model1;
//   PdfInvoiceService pdfService = PdfInvoiceService();
//   int number = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: getProportionateScreenWidth(20)),
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: model.length,
//                 itemBuilder: (context, index) {
//                   // final item = model[index];
//                   // int quantity = item.quantity;
//                   // model[index].quantity=;

//                   return Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10),
//                     child: Dismissible(
//                         key: Key(model[index].productId.toString()),
//                         direction: DismissDirection.endToStart,
//                         onDismissed: (direction) {
//                           num price =
//                               model[index].price * model[index].quantity;

//                           totalPrice = totalPrice - price;
//                           model..removeAt(index);
//                           cartStorage.deleteCartItem(index: index);

//                           setState(() {
//                             // updatePrices();

//                             // demoCarts.removeAt(index);
//                           });
//                         },
//                         background: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFFFE6E6),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Row(
//                             children: [
//                               Spacer(),
//                               SvgPicture.asset("assets/icons/Trash.svg"),
//                             ],
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 88,
//                               child: AspectRatio(
//                                 aspectRatio: 0.88,
//                                 child: Container(
//                                   padding: EdgeInsets.all(
//                                       getProportionateScreenWidth(10)),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFFF5F6F9),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   // child: Image.network(cart.product.images[0]),
//                                   child: Image.network(
//                                       model[index].productImagePath),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 20),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width / 1.8,
//                                   child: Text(
//                                     model[index].productName,
//                                     overflow: TextOverflow.ellipsis,
//                                     softWrap: true,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text.rich(
//                                   TextSpan(
//                                     text: "\$${model[index].price}",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: kPrimaryColor),
//                                     children: [
//                                       TextSpan(
//                                           // text: " x${cart.numOfItem}",
//                                           text: " x ${model[index].quantity}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyText1),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     RoundedIconBtn(
//                                       icon: Icons.remove,
//                                       showShadow: true,
//                                       press: () {
//                                         totalPrice = totalPrice -
//                                             model[index].price *
//                                                 model[index].quantity;

//                                         model[index].quantity--;
//                                         //! if quantity is less than 1 then remove item from cart
//                                         if (model[index].quantity < 1) {
//                                           cartStorage.deleteCartItem(
//                                               index: index);
//                                           model.removeAt(index);
//                                         } else {
//                                           totalPrice = totalPrice +
//                                               model[index].price *
//                                                   model[index].quantity;

//                                           cartStorage.updateCartItem(
//                                               item: model[index]);
//                                         }

//                                         // updatePrices();
//                                         setState(() {});
//                                       },
//                                     ),
//                                     SizedBox(
//                                         width: getProportionateScreenWidth(20)),
//                                     RoundedIconBtn(
//                                       icon: Icons.add,
//                                       showShadow: true,
//                                       press: () {
//                                         totalPrice = totalPrice -
//                                             model[index].price *
//                                                 model[index].quantity;

//                                         model[index].quantity++;
//                                         cartStorage.updateCartItem(
//                                             item: model[index]);

//                                         totalPrice = totalPrice +
//                                             model[index].price *
//                                                 model[index].quantity;
//                                         // updatePrices();

//                                         setState(() {});

//                                         log("quantity = ${model[index].quantity}");
//                                       },
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                           ],
//                         )),
//                   );
//                 },
//               ),
//             ),
//             PriceField(),
//             if (model.isEmpty)
//               Center(
//                 child: Text(
//                   "Your Cart is empty yet",
//                   style: nameStyle,
//                 ),
//               ),
//             if (model.isNotEmpty)
//               PaymentMethods(
//                 selectedIndex: selectedIndex,
//               ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: model.isNotEmpty
//           ? Container(
//               padding: EdgeInsets.symmetric(
//                 vertical: getProportionateScreenWidth(15),
//                 horizontal: getProportionateScreenWidth(30),
//               ),
//               // height: 174,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, -15),
//                     blurRadius: 20,
//                     color: Color(0xFFDADADA).withOpacity(0.15),
//                   )
//                 ],
//               ),
//               child: SafeArea(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: Row(
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               // print("My Model ${model1!.totalPrice}");
//                               final data = await pdfService.createInvoice(
//                                   // model1,
//                                   context);

//                               pdfService.savePdfFile("invoice_$number", data);
//                               number++;
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(10),
//                               height: getProportionateScreenWidth(40),
//                               width: getProportionateScreenWidth(40),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFF5F6F9),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child:
//                                   SvgPicture.asset("assets/icons/receipt.svg"),
//                             ),
//                           ),
//                           Spacer(),
//                           Text("Add voucher code"),
//                           const SizedBox(width: 10),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 12,
//                             color: kTextColor,
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: getProportionateScreenHeight(20)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text.rich(
//                           TextSpan(
//                             text: "Total:\n",
//                             children: [
//                               TextSpan(
//                                 text: "\$${totalPrice.toStringAsFixed(2)}",
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         DefaultButton(
//                           text: "Check Out",
//                           width: getProportionateScreenWidth(190),
//                           press: () {
//                             final jsonn = {
//                               "customer_id": "2",
//                               "salesrep_id": "3",
//                               "total_price": "200",
//                               "total_discount": "20",
//                               "sale_price": "220",
//                               "order": json.encode(model)
//                             };

//                             // model1 = PdfViewModel.fromJson(jsonn);
//                             // print("model1 $model1");

//                             log("json or order = $jsonn");
//                             showModalBottomSheet(
//                                 backgroundColor: Colors.transparent,
//                                 context: context,
//                                 builder: (context) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)),
//                                       child: ListView(
//                                         physics: NeverScrollableScrollPhysics(),
//                                         children: [
//                                           SizedBox(height: 15),
//                                           SvgPicture.asset(
//                                             'assets/icons/checkout.svg',
//                                             color: appColor,
//                                           ),
//                                           SizedBox(height: 10),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               '"Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: SizedBox(
//                                               height: 45,
//                                               width: double.infinity,
//                                               child: ElevatedButton(
//                                                 onPressed: () {},
//                                                 child:
//                                                     Text('Continue Shopping'),
//                                                 style: ElevatedButton.styleFrom(
//                                                     elevation: 0,
//                                                     backgroundColor: appColor,
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10.0))),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 10),
//                                         ],
//                                       ),

//                                       // color: Colors.black,
//                                     ),
//                                   );
//                                 });
//                             // if (selectedIndex == 0) {
//                             //   showCupertinoDialog(
//                             //       context: context,
//                             //       builder: (context) => CupertinoAlertDialog(
//                             //             title: Text(
//                             //               'Please select payment method',
//                             //               style: TextStyle(
//                             //                   fontWeight: FontWeight.w400),
//                             //             ),
//                             //             actions: [
//                             //               CupertinoDialogAction(
//                             //                 child: Text('OK'),
//                             //                 onPressed: () {
//                             //                   Navigator.pop(context);
//                             //                 },
//                             //               )
//                             //             ],
//                             //           ));
//                             // }
//                             // else {
//                             //   showModalBottomSheet(
//                             //       backgroundColor: Colors.transparent,
//                             //       context: context,
//                             //       builder: (context) {
//                             //         return Padding(
//                             //           padding: const EdgeInsets.all(8.0),
//                             //           child: Container(
//                             //             decoration: BoxDecoration(
//                             //                 color: Colors.white,
//                             //                 borderRadius:
//                             //                     BorderRadius.circular(10.0)),
//                             //             child: ListView(
//                             //               physics:
//                             //                   NeverScrollableScrollPhysics(),
//                             //               children: [
//                             //                 SizedBox(height: 15),
//                             //                 SvgPicture.asset(
//                             //                   'assets/icons/checkout.svg',
//                             //                   color: appColor,
//                             //                 ),
//                             //                 SizedBox(height: 10),
//                             //                 Padding(
//                             //                   padding:
//                             //                       const EdgeInsets.all(8.0),
//                             //                   child: Text(
//                             //                     '"Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"',
//                             //                     style: TextStyle(
//                             //                         fontWeight:
//                             //                             FontWeight.bold),
//                             //                   ),
//                             //                 ),
//                             //                 Padding(
//                             //                   padding:
//                             //                       const EdgeInsets.all(8.0),
//                             //                   child: SizedBox(
//                             //                     height: 45,
//                             //                     width: double.infinity,
//                             //                     child: ElevatedButton(
//                             //                       onPressed: () {},
//                             //                       child:
//                             //                           Text('Continue Shopping'),
//                             //                       style: ElevatedButton.styleFrom(
//                             //                           elevation: 0,
//                             //                           backgroundColor: appColor,
//                             //                           shape:
//                             //                               RoundedRectangleBorder(
//                             //                                   borderRadius:
//                             //                                       BorderRadius
//                             //                                           .circular(
//                             //                                               10.0))),
//                             //                     ),
//                             //                   ),
//                             //                 ),
//                             //                 SizedBox(height: 10),
//                             //               ],
//                             //             ),
//                             //
//                             //             // color: Colors.black,
//                             //           ),
//                             //         );
//                             //       });
//                             // }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : SizedBox(),
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       title: Column(
//         children: [
//           Text(
//             "Your Cart",
//             style: TextStyle(color: Colors.black),
//           ),
//           Text(
//             "${model.length} items",
//             style: Theme.of(context).textTheme.caption,
//           ),
//         ],
//       ),
//     );
//   }

// // void updatePrices() {
// // for (var item in model) {
// //   totalPrice += item.price;
// // }

// // model.forEach((element) {
// //   pricelist.add(element.price);
// //   discountlist.add(element.discount);
// // });
// // totalPrice = pricelist.reduce((value, element) => value + element);
// // totalDiscount = discountlist.reduce((value, element) => value + element);
// // totalDiscount = totalDiscount + element.discount * element.quantity;
// // totalPrice = element.price * element.quantity;
// //   log("totalPrice /// = $totalPrice");
// //   setState(() {});
// // }
// }
