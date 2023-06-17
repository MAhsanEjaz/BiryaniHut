class PaymentKeyGetModel {
  int? status;
  String? message;
  PaymentGetModel? data;

  PaymentKeyGetModel({this.status, this.message, this.data});

  PaymentKeyGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PaymentGetModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PaymentGetModel {
  int? id;
  String? publishableTestKey;
  String? publishableLiveKey;
  String? testSecretKey;
  String? testLiveKey;
  String? clientId;
  int? saleRepId;
  Null? saleRep;
  String? clientSecret;
  Null? paymentMethod;
  int? paymentMethodMobile;

  PaymentGetModel(
      {this.id,
        this.publishableTestKey,
        this.publishableLiveKey,
        this.testSecretKey,
        this.testLiveKey,
        this.clientId,
        this.saleRepId,
        this.saleRep,
        this.clientSecret,
        this.paymentMethod,
        this.paymentMethodMobile});

  PaymentGetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    publishableTestKey = json['publishableTestKey'];
    publishableLiveKey = json['publishableLiveKey'];
    testSecretKey = json['testSecretKey'];
    testLiveKey = json['testLiveKey'];
    clientId = json['clientId'];
    saleRepId = json['saleRepId'];
    saleRep = json['saleRep'];
    clientSecret = json['clientSecret'];
    paymentMethod = json['paymentMethod'];
    paymentMethodMobile = json['paymentMethodMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['publishableTestKey'] = publishableTestKey;
    data['publishableLiveKey'] = publishableLiveKey;
    data['testSecretKey'] = testSecretKey;
    data['testLiveKey'] = testLiveKey;
    data['clientId'] = clientId;
    data['saleRepId'] = saleRepId;
    data['saleRep'] = saleRep;
    data['clientSecret'] = clientSecret;
    data['paymentMethod'] = paymentMethod;
    data['paymentMethodMobile'] = paymentMethodMobile;
    return data;
  }
}
