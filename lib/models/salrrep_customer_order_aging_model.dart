class SaleRepCustomerOrderAgingModel {
  CustomerOrderAgingList? data;
  int? statusCode;
  String? message;

  SaleRepCustomerOrderAgingModel({this.data, this.statusCode, this.message});

  SaleRepCustomerOrderAgingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CustomerOrderAgingList.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class CustomerOrderAgingList {
  List<OrderAgingPayment>? orderPayment;
  int? saleRepTotalOrders;

  CustomerOrderAgingList({this.orderPayment, this.saleRepTotalOrders});

  CustomerOrderAgingList.fromJson(Map<String, dynamic> json) {
    if (json['orderPayment'] != null) {
      orderPayment = <OrderAgingPayment>[];
      json['orderPayment'].forEach((v) {
        orderPayment!.add(new OrderAgingPayment.fromJson(v));
      });
    }
    saleRepTotalOrders = json['saleRepTotalOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderPayment != null) {
      data['orderPayment'] = this.orderPayment!.map((v) => v.toJson()).toList();
    }
    data['saleRepTotalOrders'] = this.saleRepTotalOrders;
    return data;
  }
}

class OrderAgingPayment {
  int? id;
  String? customerName;
  int? first;
  int? second;
  int? last;

  OrderAgingPayment(
      {this.id, this.customerName, this.first, this.second, this.last});

  OrderAgingPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    first = json['first'];
    second = json['second'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerName'] = this.customerName;
    data['first'] = this.first;
    data['second'] = this.second;
    data['last'] = this.last;
    return data;
  }
}
