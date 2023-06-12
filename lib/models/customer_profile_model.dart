// class CustomerProfileModel {
//   Data? data;
//   int statusCode;
//   String message;
//
//   CustomerProfileModel({
//     this.data,
//     required this.statusCode,
//     required this.message,
//   });
//
//   factory CustomerProfileModel.fromJson(Map<String, dynamic> json) =>
//       CustomerProfileModel(
//         data: Data.fromJson(json["data"]),
//         statusCode: json["statusCode"],
//         message: json["message"],
//       );
// }
//
// class Data {
//   int id;
//   String firstName;
//   String lastName;
//   String salonName;
//   String state;
//   String city;
//   String address;
//   String? location;
//   String? customerImagePath;
//   dynamic customerImage;
//   String phone;
//   num accountBalance;
//   int? saleRepId;
//   SaleRep? saleRep;
//   int loginId;
//   dynamic deleteStatus;
//   dynamic deletedDate;
//   dynamic deletedBy;
//
//   Data({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.salonName,
//     required this.state,
//     required this.city,
//     required this.address,
//     required this.location,
//     required this.customerImagePath,
//     this.customerImage,
//     required this.phone,
//     required this.accountBalance,
//     required this.saleRepId,
//     this.saleRep,
//     required this.loginId,
//     this.deleteStatus,
//     this.deletedDate,
//     this.deletedBy,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         salonName: json["salon_Name"],
//         state: json["state"],
//         city: json["city"],
//         address: json["address"],
//         location: json["location"],
//         customerImagePath: json["customerImagePath"],
//         customerImage: json["customerImage"],
//         phone: json["phone"],
//         accountBalance: json["accountBalance"],
//         saleRepId: json["saleRepID"],
//         saleRep: SaleRep.fromJson(json["saleRep"]),
//         loginId: json["loginId"],
//         deleteStatus: json["deleteStatus"],
//         deletedDate: json["deletedDate"],
//         deletedBy: json["deletedBy"],
//       );
// }
//
// class SaleRep {
//   int id;
//   String firstName;
//   String lastName;
//   String saleRepImagePath;
//
//   SaleRep({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.saleRepImagePath,
//   });
//
//   factory SaleRep.fromJson(Map<String, dynamic> json) => SaleRep(
//         id: json["id"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         saleRepImagePath: json["saleRepImagePath"],
//       );
// }

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
  String? email;
  String? location;
  String? customerImagePath;
  Null? customerImage;
  String? phone;
  double? accountBalance;
  Null? saleRepID;
  Null? saleRep;
  int? loginId;
  Null? deleteStatus;
  Null? deletedDate;
  Null? deletedBy;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.salonName,
      this.state,
      this.city,
      this.address,
      this.email,
      this.location,
      this.customerImagePath,
      this.customerImage,
      this.phone,
      this.accountBalance,
      this.saleRepID,
      this.saleRep,
      this.loginId,
      this.deleteStatus,
      this.deletedDate,
      this.deletedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    salonName = json['salon_Name'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    email = json['email'];
    location = json['location'];
    customerImagePath = json['customerImagePath'];
    customerImage = json['customerImage'];
    phone = json['phone'];
    accountBalance = json['accountBalance'];
    saleRepID = json['saleRepID'];
    saleRep = json['saleRep'];
    loginId = json['loginId'];
    deleteStatus = json['deleteStatus'];
    deletedDate = json['deletedDate'];
    deletedBy = json['deletedBy'];
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
    data['email'] = email;
    data['location'] = location;
    data['customerImagePath'] = customerImagePath;
    data['customerImage'] = customerImage;
    data['phone'] = phone;
    data['accountBalance'] = accountBalance;
    data['saleRepID'] = saleRepID;
    data['saleRep'] = saleRep;
    data['loginId'] = loginId;
    data['deleteStatus'] = deleteStatus;
    data['deletedDate'] = deletedDate;
    data['deletedBy'] = deletedBy;
    return data;
  }
}
