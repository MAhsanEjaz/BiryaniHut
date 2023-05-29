// import 'package:flutter/material.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/size_config.dart';

// class PriceField extends StatelessWidget {
//   const PriceField({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: kSecondaryColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: TextField(
//           onChanged: (value) => print(value),
//           decoration: InputDecoration(
//               contentPadding: EdgeInsets.symmetric(
//                   horizontal: getProportionateScreenWidth(20),
//                   vertical: getProportionateScreenWidth(12)),
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               hintText: "Add Price",
//               prefixIcon: Icon(Icons.price_change)),
//         ),
//       ),
//     );
//   }
// }
