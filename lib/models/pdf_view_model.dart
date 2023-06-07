class PdfViewModel {
  int? customerId;
  int? salesrepId;
  double? totalPrice;
  int? totalDiscount;
  double? salePrice;
  List<Order>? order;

  PdfViewModel(
      {this.customerId,
      this.salesrepId,
      this.totalPrice,
      this.totalDiscount,
      this.salePrice,
      this.order});

  PdfViewModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    salesrepId = json['salesrep_id'];
    totalPrice = json['total_price'];
    totalDiscount = json['total_discount'];
    salePrice = json['sale_price'];
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['salesrep_id'] = salesrepId;
    data['total_price'] = totalPrice;
    data['total_discount'] = totalDiscount;
    data['sale_price'] = salePrice;
    if (order != null) {
      data['order'] = order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
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

  Order(
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
      this.discription});

  Order.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['price'] = price;
    data['quantity'] = quantity;
    data['lowStockthreshold'] = lowStockthreshold;
    data['regularPrice'] = regularPrice;
    data['productWaight'] = productWaight;
    data['productCode'] = productCode;
    data['productTrackingNo'] = productTrackingNo;
    data['stockStatus'] = stockStatus;
    data['visibility'] = visibility;
    data['productImagePath'] = productImagePath;
    data['productTags'] = productTags;
    data['productImage'] = productImage;
    data['discount'] = discount;
    data['discription'] = discription;
    return data;
  }
}
