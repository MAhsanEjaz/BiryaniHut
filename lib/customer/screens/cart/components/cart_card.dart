// import 'package:flutter/material.dart';
// import 'package:shop_app/components/rounded_icon_btn.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/customer/models/Cart.dart';
// import 'package:shop_app/customer/models/products_model.dart';
// import 'package:shop_app/size_config.dart';

// class CartCard extends StatelessWidget {
//   final ProductData cart;

//   const CartCard({
//     Key? key,
//     required this.cart,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 88,
//           child: AspectRatio(
//             aspectRatio: 0.88,
//             child: Container(
//               padding: EdgeInsets.all(getProportionateScreenWidth(10)),
//               decoration: BoxDecoration(
//                 color: Color(0xFFF5F6F9),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               // child: Image.network(cart.product.images[0]),
//               child: Image.asset("assets/images/image1.jpg"),
//             ),
//           ),
//         ),
//         SizedBox(width: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               cart.productName,
//               style: TextStyle(color: Colors.black, fontSize: 16),
//               maxLines: 2,
//             ),
//             SizedBox(height: 10),
//             Text.rich(
//               TextSpan(
//                 text: "\$${cart.price}",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600, color: kPrimaryColor),
//                 children: [
//                   TextSpan(
//                       // text: " x${cart.numOfItem}",
//                       text: "11111",
//                       style: Theme.of(context).textTheme.bodyText1),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Spacer(),
//                 RoundedIconBtn(
//                   icon: Icons.remove,
//                   showShadow: true,
//                   press: () {},
//                 ),
//                 SizedBox(width: getProportionateScreenWidth(20)),
//                 RoundedIconBtn(
//                   icon: Icons.add,
//                   showShadow: true,
//                   press: () {},
//                 ),
//               ],
//             )
//           ],
//         )
//       ],
//     );
//   }
// }
