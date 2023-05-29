// class FavouritesProductsModel {
//   List<FavouritesProducts>? data;
//   int? statusCode;
//   String? message;

//   FavouritesProductsModel({this.data, this.statusCode, this.message});

//   FavouritesProductsModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <FavouritesProducts>[];
//       json['data'].forEach((v) {
//         data!.add(new FavouritesProducts.fromJson(v));
//       });
//     }
//     statusCode = json['statusCode'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['statusCode'] = this.statusCode;
//     data['message'] = this.message;
//     return data;
//   }
// }

// class FavouritesProducts {
//   int? productId;
//   double? price;
//   int? quantity;
//   double? totalCost;
//   double? discount;
//   double? totalPrice;
//   String? productName;
//   String? productDescription;
//   String? productImagePath;
//   String? productImage;

//   FavouritesProducts(
//       {this.productId,
//         this.price,
//         this.quantity,
//         this.totalCost,
//         this.discount,
//         this.totalPrice,
//         this.productName,
//         this.productDescription,
//         this.productImagePath,
//         this.productImage});

//   FavouritesProducts.fromJson(Map<String, dynamic> json) {
//     productId = json['productId'];
//     price = json['price'];
//     quantity = json['quantity'];
//     totalCost = json['totalCost'];
//     discount = json['discount'];
//     totalPrice = json['totalPrice'];
//     productName = json['productName'];
//     productDescription = json['productDescription'];
//     productImagePath = json['productImagePath'];
//     productImage = json['productImage'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['productId'] = this.productId;
//     data['price'] = this.price;
//     data['quantity'] = this.quantity;
//     data['totalCost'] = this.totalCost;
//     data['discount'] = this.discount;
//     data['totalPrice'] = this.totalPrice;
//     data['productName'] = this.productName;
//     data['productDescription'] = this.productDescription;
//     data['productImagePath'] = this.productImagePath;
//     data['productImage'] = this.productImage;
//     return data;
//   }
// }
