// To parse this JSON data, do
//
//     final salesrepOrdersModel = salesrepOrdersModelFromJson(jsonString);

import 'dart:convert';

SalesrepOrdersModel salesrepOrdersModelFromJson(String str) =>
    SalesrepOrdersModel.fromJson(json.decode(str));

String salesrepOrdersModelToJson(SalesrepOrdersModel data) =>
    json.encode(data.toJson());

class SalesrepOrdersModel {
  SalesrepOrdersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  int status;
  String message;
  List<Datum> data;

  factory SalesrepOrdersModel.fromJson(Map<String, dynamic> json) =>
      SalesrepOrdersModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.lowStockthreshold,
    required this.regularPrice,
    required this.productWaight,
    required this.productCode,
    required this.productTrackingNo,
    required this.stockStatus,
    required this.visibility,
    required this.productImagePath,
    required this.productTags,
    required this.productImage,
    required this.discount,
    required this.discription,
  });

  int productId;
  String productName;
  double price;
  int quantity;
  int lowStockthreshold;
  double regularPrice;
  int productWaight;
  String productCode;
  String productTrackingNo;
  String stockStatus;
  String visibility;
  String productImagePath;
  String productTags;
  String productImage;
  int discount;
  String discription;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        lowStockthreshold: json["lowStockthreshold"],
        regularPrice: json["regularPrice"]?.toDouble(),
        productWaight: json["productWaight"],
        productCode: json["productCode"],
        productTrackingNo: json["productTrackingNo"],
        stockStatus: json["stockStatus"],
        visibility: json["visibility"],
        productImagePath: json["productImagePath"],
        productTags: json["productTags"],
        productImage: json["productImage"],
        discount: json["discount"],
        discription: json["discription"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "price": price,
        "quantity": quantity,
        "lowStockthreshold": lowStockthreshold,
        "regularPrice": regularPrice,
        "productWaight": productWaight,
        "productCode": productCode,
        "productTrackingNo": productTrackingNo,
        "stockStatus": stockStatus,
        "visibility": visibility,
        "productImagePath": productImagePath,
        "productTags": productTags,
        "productImage": productImage,
        "discount": discount,
        "discription": discription,
      };
}
