class CostOfGoodSaleModel {
  List<GoodSaleModel>? data;
  int? statusCode;
  String? message;

  CostOfGoodSaleModel({this.data, this.statusCode, this.message});

  CostOfGoodSaleModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GoodSaleModel>[];
      json['data'].forEach((v) {
        data!.add(GoodSaleModel.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class GoodSaleModel {
  int? productId;
  String? productName;
  int? quantity;
  double? cost;
  double? revenue;

  GoodSaleModel(
      {this.productId,
      this.productName,
      this.quantity,
      this.cost,
      this.revenue});

  GoodSaleModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    cost = json['cost'];
    revenue = json['revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['cost'] = cost;
    data['revenue'] = revenue;
    return data;
  }
}
