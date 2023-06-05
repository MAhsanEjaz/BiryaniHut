class TopFiveProductsModel {
  int? productId;
  String? productName;
  int? totalOrders;

  TopFiveProductsModel({this.productId, this.productName, this.totalOrders});

  TopFiveProductsModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    totalOrders = json['totalOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['totalOrders'] = this.totalOrders;
    return data;
  }
}
