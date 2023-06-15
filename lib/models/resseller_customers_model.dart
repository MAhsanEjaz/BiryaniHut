class ResellerCustomersModel {
  List<SalesrepCustomerData>? data;
  int? statusCode;
  String? message;

  ResellerCustomersModel({this.data, this.statusCode, this.message});

  ResellerCustomersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesrepCustomerData>[];
      json['data'].forEach((v) {
        data!.add(SalesrepCustomerData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class SalesrepCustomerData {
  int? id;
  String? firstName;
  String? lastName;
  String? salonName;
  String? state;
  String? city;
  String? address;
  String? email;
  String? customerImageFile;
  String? location;
  String? customerImagePath;
  String? customerImage;
  String? phone;
  int? saleRepID;
  dynamic saleRep;
  int? loginId;
  Login? login;
  dynamic customerOrders;

  SalesrepCustomerData(
      {this.id,
      this.firstName,
      this.lastName,
      this.salonName,
      this.customerImageFile,
      this.state,
      this.city,
        this.email,
      this.address,
      this.location,
      this.customerImagePath,
      this.customerImage,
      this.phone,
      this.saleRepID,
      this.saleRep,
      this.loginId,
      this.login,
      this.customerOrders});

  SalesrepCustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    email = json['email'];
    lastName = json['lastName'];
    customerImageFile = json['customerImageFile'];
    salonName = json['salon_Name'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    location = json['location'];
    customerImagePath = json['customerImageFile'];
    customerImage = json['customerImage'];
    phone = json['phone'];
    saleRepID = json['saleRepID'];
    saleRep = json['saleRep'];
    loginId = json['loginId'];
    login = json['login'] != null ? Login.fromJson(json['login']) : null;
    customerOrders = json['customerOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['email'] = email;
    data['lastName'] = lastName;
    data['salon_Name'] = salonName;
    data['state'] = state;
    data['customerImageFile'] = customerImageFile;
    data['city'] = city;
    data['address'] = address;
    data['location'] = location;
    data['customerImageFile'] = customerImagePath;
    data['customerImage'] = customerImage;
    data['phone'] = phone;
    data['saleRepID'] = saleRepID;
    data['saleRep'] = saleRep;
    data['loginId'] = loginId;
    if (login != null) {
      data['login'] = login!.toJson();
    }
    data['customerOrders'] = customerOrders;
    return data;
  }
}







class Login {
  int? loginId;
  int? roleId;
  String? email;
  String? password;
  bool? isActive;
  dynamic saleRep;

  Login(
      {this.loginId,
      this.roleId,
      this.email,
      this.password,
      this.isActive,
      this.saleRep});

  Login.fromJson(Map<String, dynamic> json) {
    loginId = json['loginId'];
    roleId = json['roleId'];
    email = json['email'];
    password = json['password'];
    isActive = json['isActive'];
    saleRep = json['saleRep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginId'] = loginId;
    data['roleId'] = roleId;
    data['email'] = email;
    data['password'] = password;
    data['isActive'] = isActive;
    data['saleRep'] = saleRep;
    return data;
  }
}
