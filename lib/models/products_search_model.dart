class ProductsSearchModel {
  int? status;
  String? message;
  List<ProductsSearchList>? data;

  ProductsSearchModel({this.status, this.message, this.data});

  ProductsSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductsSearchList>[];
      json['data'].forEach((v) {
        data!.add(new ProductsSearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsSearchList {
  int? productId;
  String? productName;
  double? price;
  int? quantity;
  int? lowStockthreshold;
  double? regularPrice;
  int? productWaight;
  String? productCode;
  String? productTrackingNo;
  String? stockStatus;
  String? visibility;
  String? productImagePath;
  String? productTags;
  String? productImage;
  int? discount;
  String? discription;
  Null? orders;

  ProductsSearchList(
      {this.productId,
        this.productName,
        this.price,
        this.quantity,
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
        this.discount,
        this.discription,
        this.orders});

  ProductsSearchList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    price = json['price'];
    quantity = json['quantity'];
    lowStockthreshold = json['lowStockthreshold'];
    regularPrice = json['regularPrice'];
    productWaight = json['productWaight'];
    productCode = json['productCode'];
    productTrackingNo = json['productTrackingNo'];
    stockStatus = json['stockStatus'];
    visibility = json['visibility'];
    productImagePath = json['productImagePath'];
    productTags = json['productTags'];
    productImage = json['productImage'];
    discount = json['discount'];
    discription = json['discription'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['lowStockthreshold'] = this.lowStockthreshold;
    data['regularPrice'] = this.regularPrice;
    data['productWaight'] = this.productWaight;
    data['productCode'] = this.productCode;
    data['productTrackingNo'] = this.productTrackingNo;
    data['stockStatus'] = this.stockStatus;
    data['visibility'] = this.visibility;
    data['productImagePath'] = this.productImagePath;
    data['productTags'] = this.productTags;
    data['productImage'] = this.productImage;
    data['discount'] = this.discount;
    data['discription'] = this.discription;
    data['orders'] = this.orders;
    return data;
  }
}
