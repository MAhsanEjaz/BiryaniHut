class AccountBalanceModel {
  Data? data;
  int? statusCode;
  String? message;

  AccountBalanceModel({this.data, this.statusCode, this.message});

  AccountBalanceModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? customerId;
  num? accountBalance;
  num? creditLimit;

  Data({this.customerId, this.accountBalance, this.creditLimit});

  Data.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    accountBalance = json['accountBalance'];
    creditLimit = json['creditLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['accountBalance'] = this.accountBalance;
    data['creditLimit'] = this.creditLimit;
    return data;
  }
}
