class UserModel {
  LoginData? data;
  int? statusCode;
  String? message;

  UserModel({this.data, this.statusCode, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
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

class LoginData {
  String? imagePath;
  String? imageName;
  int? id;
  String? firstName;
  String? lastName;
  String? salonName;
  String? state;
  String? city;
  String? address;
  String? location;
  String? phone;
  double? rating;
  num? discount = 0;
  int? saleRepId;
  String? saleRepName;
  String? token;
  num? loginId;
  int? roleId;
  String? email;
  String? password;
  bool? isActive;
  String? companyName;

  LoginData({
    this.imagePath,
    this.imageName,
    this.id,
    this.firstName,
    this.lastName,
    this.salonName,
    this.state,
    this.city,
    this.address,
    this.location,
    this.phone,
    this.rating,
    this.discount,
    this.saleRepId,
    this.saleRepName,
    this.token,
    this.loginId,
    this.roleId,
    this.email,
    this.password,
    this.isActive,
    this.companyName,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];
    imageName = json['imageName'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    salonName = json['salon_Name'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    location = json['location'];
    phone = json['phone'];
    rating = json['rating'];
    discount = json['discount'] ?? 0;
    saleRepId = json['saleRepId'];
    saleRepName = json['saleRepName'];
    token = json['token'];
    loginId = json['loginId'];
    roleId = json['roleId'];
    email = json['email'];
    password = json['password'];
    isActive = json['isActive'];
    companyName = json['companyName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imagePath'] = imagePath;
    data['imageName'] = imageName;
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['salon_Name'] = salonName;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['location'] = location;
    data['phone'] = phone;
    data['rating'] = rating;
    data['discount'] = discount;
    data['saleRepId'] = saleRepId;
    data['saleRepName'] = saleRepName;
    data['token'] = token;
    data['loginId'] = loginId;
    data['roleId'] = roleId;
    data['email'] = email;
    data['password'] = password;
    data['isActive'] = isActive;
    data['companyName'] = companyName;
    return data;
  }
}
