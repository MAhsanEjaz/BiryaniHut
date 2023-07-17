// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

// ProductsModel productsModelFromJson(String str) =>
//     ProductsModel.fromJson(json.decode(str));
//
// String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ProductsModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<ProductData>? data;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        status: json["status"],
        message: json["message"],
        data: List<ProductData>.from(
            json["data"].map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProductData {
  ProductData({
    required this.productId,
    required this.productName,
    required this.salePrice,
    required this.quantity,
    this.lowStockthreshold,
    this.regularPrice,
    this.productWaight,
    this.productCode,
    this.productTrackingNo,
    this.stockStatus,
    this.visibility,
    this.productImagePath,
    this.productTags,
    this.productImage,
    required this.discount,
    required this.discription,
  });

  int productId;
  String productName;
  num salePrice;
  num quantity;
  num? lowStockthreshold;
  num? regularPrice;
  num? productWaight;
  String? productCode;
  String? productTrackingNo;
  String? stockStatus;
  String? visibility;
  String? productImagePath = "";
  String? productTags;
  String? productImage;
  num discount;
  String discription;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        productId: json["productId"],
        productName: json["productName"],
        salePrice: json["salePrice"]?.toDouble() ?? 0,
        // quantity: json["quantity"],
        quantity: json["quantity"] ?? 0,
        lowStockthreshold: json["lowStockthreshold"],
        regularPrice: json["regularPrice"]?.toDouble(),
        productWaight: json["productWaight"],
        productCode: json["productCode"],
        productTrackingNo: json["productTrackingNo"],
        stockStatus: json["stockStatus"],
        visibility: json["visibility"],
        productImagePath: json["productImagePath"] ?? "",
        productTags: json["productTags"],
        productImage: json["productImage"] ?? "",
        discount: json["discount"] ?? 0,
        discription: json["discription"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "salePrice": salePrice,
        "quantity": quantity,
        "lowStockthreshold": lowStockthreshold,
        "regularPrice": regularPrice,
        "productWaight": productWaight,
        "productCode": productCode,
        "productTrackingNo": productTrackingNo,
        "stockStatus": stockStatus,
        "visibility": visibility,
        "productImagePath": productImagePath ?? "",
        "productTags": productTags,
        "productImage": productImage,
        "discount": discount,
        "discription": discription,
      };
}
