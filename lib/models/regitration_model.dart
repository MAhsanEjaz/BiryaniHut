class RegistrationModel {
  Null? data;
  int? statusCode;
  String? message;

  RegistrationModel({this.data, this.statusCode, this.message});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
