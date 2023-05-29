// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/custom_handlers.dart';
// import 'package:shop_app/models/products_model.dart';
//
// import 'providers/products_provider.dart';
//
// class MyPracticeProductScreen extends StatefulWidget {
//   const MyPracticeProductScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyPracticeProductScreen> createState() =>
//       _MyPracticeProductScreenState();
// }
//
// class _MyPracticeProductScreenState extends State<MyPracticeProductScreen> {
//   // List<ProductData> productsSearchList = [];
//
//   String query = '';
//
//   List<ProductData> get myData {
//     final productProvider =
//         Provider.of<ProductsProvider>(context, listen: false);
//     final queryLower = query.toLowerCase();
//
//     return productProvider.prod!.where((element) {
//       final nameLower = element.productName.toLowerCase();
//       return nameLower.contains(queryLower);
//     }).toList();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       getProductsHandler(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           title: Text('products'),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   onChanged: (val) {
//                     query = val;
//                     setState(() {});
//                   },
//                 ),
//                 myData.isNotEmpty
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: myData.length,
//                         itemBuilder: (context, index) {
//                           return Text(myData[index].productName);
//                         })
//                     : Text('Not Found')
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
