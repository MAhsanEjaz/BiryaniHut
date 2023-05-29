class SalerepAllCustomerPaymentModel {
  List<SalesRepAllCustomersList>? data;
  int? statusCode;
  String? message;

  SalerepAllCustomerPaymentModel({this.data, this.statusCode, this.message});

  SalerepAllCustomerPaymentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesRepAllCustomersList>[];
      json['data'].forEach((v) {
        data!.add(new SalesRepAllCustomersList.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class SalesRepAllCustomersList {
  int? id;
  double? totalAmountPaid;
  double? totalOrderPurchase;
  String? customerName;

  SalesRepAllCustomersList(
      {this.id,
        this.totalAmountPaid,
        this.totalOrderPurchase,
        this.customerName});

  SalesRepAllCustomersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmountPaid = json['totalAmountPaid'];
    totalOrderPurchase = json['totalOrderPurchase'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalAmountPaid'] = this.totalAmountPaid;
    data['totalOrderPurchase'] = this.totalOrderPurchase;
    data['customerName'] = this.customerName;
    return data;
  }
}
