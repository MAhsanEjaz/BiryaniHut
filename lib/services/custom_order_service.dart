// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/helper/custom_get_request_service.dart';
// import 'package:shop_app/helper/custom_snackbar.dart';
// import 'package:shop_app/models/customer_order_model.dart';
// import 'package:shop_app/providers/customer_order_provider.dart';
// import 'package:shop_app/providers/user_data_provider.dart';
// import 'package:shop_app/storages/login_storage.dart';

// class CustomerOrderService {
//   Future customerOrderService({required BuildContext context}) async {
//     try {
//       var id = LoginStorage().getUserId();
//       // int id =
//       //     Provider.of<UserDataProvider>(context, listen: false).user!.data!.id;
//       var res = await CustomGetRequestService().httpGetRequest(
//           context: context, url: '$baseUrl/Order/GetCustomerOrders/$id');

//       log('customerId--->$id');

//       if (res != null) {
//         CustomerOrederModel customerOrederModel =
//             CustomerOrederModel.fromJson(res);
//         Provider.of<CustomerOrderProvider>(context, listen: false)
//             .getOrders(newOrderModel: customerOrederModel.data);
//         if (customerOrederModel.data != null &&
//             customerOrederModel.data!.isEmpty) {
//           CustomSnackBar.failedSnackBar(
//               context: context, message: "No Orders to show");
//         }
//       } else {
//         CustomSnackBar.failedSnackBar(
//             context: context, message: "No Orders to show");
//       }
//     } catch (err) {
//       CustomSnackBar.failedSnackBar(context: context, message: "$err");
//     }
//   }
// }
