class SalesRepCustomerPaymentAgingModel {
  List<CustomerPaymentAgingList>? data;
  int? statusCode;
  String? message;

  SalesRepCustomerPaymentAgingModel({this.data, this.statusCode, this.message});

  SalesRepCustomerPaymentAgingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerPaymentAgingList>[];
      json['data'].forEach((v) {
        data!.add(new CustomerPaymentAgingList.fromJson(v));
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

class CustomerPaymentAgingList {
  int? id;
  double? currentPending;
  String? customerName;
  double? first;
  double? second;
  double? third;
  double? last;

  CustomerPaymentAgingList(
      {this.id,
        this.currentPending,
        this.customerName,
        this.first,
        this.second,
        this.third,
        this.last});

  CustomerPaymentAgingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentPending = json['currentPending'];
    customerName = json['customerName'];
    first = json['first'];
    second = json['second'];
    third = json['third'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currentPending'] = this.currentPending;
    data['customerName'] = this.customerName;
    data['first'] = this.first;
    data['second'] = this.second;
    data['third'] = this.third;
    data['last'] = this.last;
    return data;
  }
}
