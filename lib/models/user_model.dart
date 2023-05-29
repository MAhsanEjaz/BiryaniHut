class UserModel {
  LoginData? data;
  int? statusCode;
  String? message;

  UserModel({this.data, this.statusCode, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
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
  num? discount;
  int? saleRepId;
  String? saleRepName;
  String? token;
  num? loginId;
  int? roleId;
  String? email;
  String? password;
  bool? isActive;

  LoginData(
      {this.imagePath,
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
        this.isActive});

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
    discount = json['discount'];
    saleRepId = json['saleRepId'];
    saleRepName = json['saleRepName'];
    token = json['token'];
    loginId = json['loginId'];
    roleId = json['roleId'];
    email = json['email'];
    password = json['password'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    data['imageName'] = this.imageName;
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['salon_Name'] = this.salonName;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['discount'] = this.discount;
    data['saleRepId'] = this.saleRepId;
    data['saleRepName'] = this.saleRepName;
    data['token'] = this.token;
    data['loginId'] = this.loginId;
    data['roleId'] = this.roleId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['isActive'] = this.isActive;
    return data;
  }
}
