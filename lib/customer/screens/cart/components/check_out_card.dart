// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shop_app/components/default_button.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/customer/screens/cart/components/apple_button.dart';
// import 'package:shop_app/customer/screens/cart/components/google_play_button.dart';
// import 'package:shop_app/customer/screens/cart/components/payment_card.dart';
// import 'package:shop_app/customer/screens/cart/components/pdf_service.dart';
// import 'package:shop_app/size_config.dart';
// import 'package:http/http.dart' as http;

// class CheckoutCard extends StatefulWidget {

//   int? selectedIndex;

//   CheckoutCard({this.selectedIndex});

//   @override
//   State<CheckoutCard> createState() => _CheckoutCardState();
// }

// class _CheckoutCardState extends State<CheckoutCard> {


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: getProportionateScreenWidth(15),
//         horizontal: getProportionateScreenWidth(30),
//       ),
//       // height: 174,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -15),
//             blurRadius: 20,
//             color: Color(0xFFDADADA).withOpacity(0.15),
//           )
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       final pdf =
//                           await PdfServiceApi.generateTextPdfForm('', '', '');
//                       PdfServiceApi.openFile(pdf);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       height: getProportionateScreenWidth(40),
//                       width: getProportionateScreenWidth(40),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF5F6F9),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: SvgPicture.asset("assets/icons/receipt.svg"),
//                     ),
//                   ),
//                   Spacer(),
//                   Text("Add voucher code"),
//                   const SizedBox(width: 10),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 12,
//                     color: kTextColor,
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(height: getProportionateScreenHeight(20)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                     text: "Total:\n",
//                     children: [
//                       TextSpan(
//                         text: "\$337.15",
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//                 DefaultButton(
//                   text: "Check Out",
//                   width: getProportionateScreenWidth(190),
//                   press: () {
//                     widget.selectedIndex == null
//                         ? showCupertinoDialog(
//                             context: context,
//                             builder: (context) => CupertinoAlertDialog(
//                                   title: Text(
//                                     'Please select payment method',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w400),
//                                   ),
//                                   actions: [
//                                     CupertinoDialogAction(
//                                       child: Text('OK'),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                     )
//                                   ],
//                                 ))
//                         : showModalBottomSheet(
//                             backgroundColor: Colors.transparent,
//                             context: context,
//                             builder: (context) => Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(10.0)),
//                                     child: ListView(
//                                       physics: NeverScrollableScrollPhysics(),
//                                       children: [
//                                         SizedBox(height: 15),
//                                         SvgPicture.asset(
//                                           'assets/icons/checkout.svg',
//                                           color: appColor,
//                                         ),
//                                         SizedBox(height: 10),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             '"Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: SizedBox(
//                                             height: 45,
//                                             width: double.infinity,
//                                             child: ElevatedButton(
//                                               onPressed: () {},
//                                               child: Text('Continue Shopping'),
//                                               style: ElevatedButton.styleFrom(
//                                                   elevation: 0,
//                                                   shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10.0)),
//                                                   primary: appColor),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                       ],
//                                     ),

//                                     // color: Colors.black,
//                                   ),
//                                 ));
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
