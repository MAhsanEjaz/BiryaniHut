// class UserModel {
//   LoginData? data;
//   int? statusCode;
//   String? message;
//
//   UserModel({this.data, this.statusCode, this.message});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
//     statusCode = json['statusCode'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['statusCode'] = statusCode;
//     data['message'] = message;
//     return data;
//   }
// }
//
// class LoginData {
//   String? imagePath;
//   String? imageName;
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? salonName;
//   String? state;
//   String? city;
//   String? address;
//   String? location;
//   String? phone;
//   double? rating;
//   num? discount = 0;
//   int? saleRepId;
//   String? saleRepName;
//   String? token;
//   num? loginId;
//   int? roleId;
//   String? email;
//   String? password;
//   bool? isActive;
//   String? companyName;
//
//   LoginData({
//     this.imagePath,
//     this.imageName,
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.salonName,
//     this.state,
//     this.city,
//     this.address,
//     this.location,
//     this.phone,
//     this.rating,
//     this.discount,
//     this.saleRepId,
//     this.saleRepName,
//     this.token,
//     this.loginId,
//     this.roleId,
//     this.email,
//     this.password,
//     this.isActive,
//     this.companyName,
//   });
//
//   LoginData.fromJson(Map<String, dynamic> json) {
//     imagePath = json['imagePath'];
//     imageName = json['imageName'];
//     id = json['id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     salonName = json['salon_Name'];
//     state = json['state'];
//     city = json['city'];
//     address = json['address'];
//     location = json['location'];
//     phone = json['phone'];
//     rating = json['rating'];
//     discount = json['discount'] ?? 0;
//     saleRepId = json['saleRepId']; //saleRepId
//     saleRepName = json['saleRepName'];
//     token = json['token'];
//     loginId = json['loginId'];
//     roleId = json['roleId'];
//     email = json['email'];
//     password = json['password'];
//     isActive = json['isActive'];
//     companyName = json['companyName'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['imagePath'] = imagePath;
//     data['imageName'] = imageName;
//     data['id'] = id;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['salon_Name'] = salonName;
//     data['state'] = state;
//     data['city'] = city;
//     data['address'] = address;
//     data['location'] = location;
//     data['phone'] = phone;
//     data['rating'] = rating;
//     data['discount'] = discount;
//     data['saleRepId'] = saleRepId;
//     data['saleRepName'] = saleRepName;
//     data['token'] = token;
//     data['loginId'] = loginId;
//     data['roleId'] = roleId;
//     data['email'] = email;
//     data['password'] = password;
//     data['isActive'] = isActive;
//     data['companyName'] = companyName;
//     return data;
//   }
// }

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
  String? companyName;
  String? address;
  String? location;
  String? phone;
  num? rating;
  num? discount;
  num? discountType;
  int? userId;
  String? usersName;
  String? token;
  PaymentGateway? paymentGateway;
  int? loginId;
  int? roleId;
  String? roleName;
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
        this.companyName,
        this.address,
        this.location,
        this.phone,
        this.rating,
        this.discount,
        this.discountType,
        this.userId,
        this.usersName,
        this.token,
        this.paymentGateway,
        this.loginId,
        this.roleId,
        this.roleName,
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
    companyName = json['companyName'];
    address = json['address'];
    location = json['location'];
    phone = json['phone'];
    rating = json['rating'];
    discount = json['discount'];
    discountType = json['discountType'];
    userId = json['userId'];
    usersName = json['usersName'];
    token = json['token'];
    paymentGateway = json['paymentGateway'] != null
        ? new PaymentGateway.fromJson(json['paymentGateway'])
        : null;
    loginId = json['loginId'];
    roleId = json['roleId'];
    roleName = json['roleName'];
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
    data['companyName'] = this.companyName;
    data['address'] = this.address;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['discount'] = this.discount;
    data['discountType'] = this.discountType;
    data['userId'] = this.userId;
    data['usersName'] = this.usersName;
    data['token'] = this.token;
    if (this.paymentGateway != null) {
      data['paymentGateway'] = this.paymentGateway!.toJson();
    }
    data['loginId'] = this.loginId;
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['isActive'] = this.isActive;
    return data;
  }
}

class PaymentGateway {
  int? id;
  String? publishableTestKey;
  String? publishableLiveKey;
  String? testSecretKey;
  String? testLiveKey;
  String? clientId;
  Null? userId;
  Null? users;
  String? clientSecret;
  Null? paymentMethod;
  int? paymentMethodMobile;

  PaymentGateway(
      {this.id,
        this.publishableTestKey,
        this.publishableLiveKey,
        this.testSecretKey,
        this.testLiveKey,
        this.clientId,
        this.userId,
        this.users,
        this.clientSecret,
        this.paymentMethod,
        this.paymentMethodMobile});

  PaymentGateway.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    publishableTestKey = json['publishableTestKey'];
    publishableLiveKey = json['publishableLiveKey'];
    testSecretKey = json['testSecretKey'];
    testLiveKey = json['testLiveKey'];
    clientId = json['clientId'];
    userId = json['userId'];
    users = json['users'];
    clientSecret = json['clientSecret'];
    paymentMethod = json['paymentMethod'];
    paymentMethodMobile = json['paymentMethodMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['publishableTestKey'] = this.publishableTestKey;
    data['publishableLiveKey'] = this.publishableLiveKey;
    data['testSecretKey'] = this.testSecretKey;
    data['testLiveKey'] = this.testLiveKey;
    data['clientId'] = this.clientId;
    data['userId'] = this.userId;
    data['users'] = this.users;
    data['clientSecret'] = this.clientSecret;
    data['paymentMethod'] = this.paymentMethod;
    data['paymentMethodMobile'] = this.paymentMethodMobile;
    return data;
  }
}


