class SaleRepPaymentsReportModel {
  PaymentsReport? data;
  num? statusCode;
  String? message;

  SaleRepPaymentsReportModel({this.data, this.statusCode, this.message});

  SaleRepPaymentsReportModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? PaymentsReport.fromJson(json['data']) : null;
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

class PaymentsReport {
  List<Payments>? payments;
  num? totalAmountPaid;
  num? totalOrderPurchase;

  PaymentsReport(
      {this.payments, this.totalAmountPaid, this.totalOrderPurchase});

  PaymentsReport.fromJson(Map<String, dynamic> json) {
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(Payments.fromJson(v));
      });
    }
    totalAmountPaid = json['totalAmountPaid'];
    totalOrderPurchase = json['totalOrderPurchase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    data['totalAmountPaid'] = totalAmountPaid;
    data['totalOrderPurchase'] = totalOrderPurchase;
    return data;
  }
}

class Payments {
  num? id;
  String? paymentMethod;
  num? paymentAmount;
  String? chequeNumber;
  String? paymentDateTime;
  num? customerId;
  String? customerName;

  Payments(
      {this.id,
      this.paymentMethod,
      this.paymentAmount,
      this.chequeNumber,
      this.paymentDateTime,
      this.customerName,
      this.customerId});

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['paymentMethod'];
    paymentAmount = json['paymentAmount'];
    chequeNumber = json['chequeNumber'];
    paymentDateTime = json['paymentDateTime'];
    customerId = json['customerId'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paymentMethod'] = paymentMethod;
    data['paymentAmount'] = paymentAmount;
    data['chequeNumber'] = chequeNumber;
    data['paymentDateTime'] = paymentDateTime;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    return data;
  }
}
