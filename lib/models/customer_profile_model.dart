class CustomerProfileModel {
  Data? data;
  int? statusCode;
  String? message;

  CustomerProfileModel({this.data, this.statusCode, this.message});

  CustomerProfileModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? firstName;
  String? lastName;
  String? salonName;
  String? state;
  String? city;
  String? address;
  String? location;
  String? customerImagePath;
  String? customerImage;
  String? phone;
  double? accountBalance;
  int? saleRepID;
  String? saleRep;
  int? loginId;
  String? login;
  String? customerOrders;
  String? favoriteProducts;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.salonName,
      this.state,
      this.city,
      this.address,
      this.location,
      this.customerImagePath,
      this.customerImage,
      this.phone,
      this.accountBalance,
      this.saleRepID,
      this.saleRep,
      this.loginId,
      this.login,
      this.customerOrders,
      this.favoriteProducts});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    salonName = json['salon_Name'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    location = json['location'];
    customerImagePath = json['customerImagePath'];
    customerImage = json['customerImage'];
    phone = json['phone'];
    accountBalance = json['accountBalance'];
    saleRepID = json['saleRepID'];
    saleRep = json['saleRep'];
    loginId = json['loginId'];
    login = json['login'];
    customerOrders = json['customerOrders'];
    favoriteProducts = json['favoriteProducts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['salon_Name'] = salonName;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['location'] = location;
    data['customerImagePath'] = customerImagePath;
    data['customerImage'] = customerImage;
    data['phone'] = phone;
    data['accountBalance'] = accountBalance;
    data['saleRepID'] = saleRepID;
    data['saleRep'] = saleRep;
    data['loginId'] = loginId;
    data['login'] = login;
    data['customerOrders'] = customerOrders;
    data['favoriteProducts'] = favoriteProducts;
    return data;
  }
}
