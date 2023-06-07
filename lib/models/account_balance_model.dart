class AccountBalanceModel {
  Data? data;
  int? statusCode;
  String? message;

  AccountBalanceModel({this.data, this.statusCode, this.message});

  AccountBalanceModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = statusCode;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['accountBalance'] = accountBalance;
    data['creditLimit'] = creditLimit;
    return data;
  }
}
