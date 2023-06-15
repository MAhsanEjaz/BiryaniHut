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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? customerImage;
  String? customerImageFile;

  String? phone;
  double? accountBalance;
  int? saleRepID;
  SaleRep? saleRep;
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
    saleRep =
    json['saleRep'] != null ? new SaleRep.fromJson(json['saleRep']) : null;
    loginId = json['loginId'];
    deleteStatus = json['deleteStatus'];
    deletedDate = json['deletedDate'];
    deletedBy = json['deletedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['salon_Name'] = this.salonName;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['email'] = this.email;
    data['location'] = this.location;
    data['customerImagePath'] = this.customerImagePath;
    data['customerImage'] = this.customerImage;
    data['phone'] = this.phone;
    data['accountBalance'] = this.accountBalance;
    data['saleRepID'] = this.saleRepID;
    if (this.saleRep != null) {
      data['saleRep'] = this.saleRep!.toJson();
    }
    data['loginId'] = this.loginId;
    data['deleteStatus'] = this.deleteStatus;
    data['deletedDate'] = this.deletedDate;
    data['deletedBy'] = this.deletedBy;
    return data;
  }
}

class SaleRep {
  int? id;
  String? firstName;
  String? lastName;
  String? saleRepImagePath;

  SaleRep({this.id, this.firstName, this.lastName, this.saleRepImagePath});

  SaleRep.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    saleRepImagePath = json['saleRepImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['saleRepImagePath'] = this.saleRepImagePath;
    return data;
  }
}

