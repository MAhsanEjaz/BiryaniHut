// To parse this JSON data, do
//
//     final salesrepProfileModel = salesrepProfileModelFromJson(jsonString);

// import 'dart:convert';

// SalesrepProfileModel salesrepProfileModelFromJson(String str) =>
//     SalesrepProfileModel.fromJson(json.decode(str));

// String salesrepProfileModelToJson(SalesrepProfileModel data) =>
//     json.encode(data.toJson());

class SalesrepProfileModel {
  Data data;
  num statusCode;
  String message;

  SalesrepProfileModel({
    required this.data,
    required this.statusCode,
    required this.message,
  });

  factory SalesrepProfileModel.fromJson(Map<String, dynamic> json) =>
      SalesrepProfileModel(
        data: Data.fromJson(json["data"]),
        statusCode: json["statusCode"],
        message: json["message"],
      );

// Map<String, dynamic> toJson() => {
//       "data": data.toJson(),
//       "statusCode": statusCode,
//       "message": message,
//     };
}

class Data {
  String email;
  String password;
  num roleId;
  dynamic bytefile;
  num id;
  String firstName;
  String lastName;
  String state;
  String city;
  String address;
  String location;
  String companyName;
  String phone;
  num rating;
  num? discount;
  dynamic status;
  String saleRepImagePath;
  String saleRepImage;

  Data({
    required this.email,
    required this.password,
    required this.roleId,
    required this.companyName,
    this.bytefile,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.state,
    required this.city,
    required this.address,
    required this.location,
    required this.phone,
    required this.rating,
    required this.discount,
    this.status,
    required this.saleRepImagePath,
    required this.saleRepImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        password: json["password"],
        roleId: json["roleId"],
        bytefile: json["bytefile"],
        companyName: json["companyName"],
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        location: json["location"],
        phone: json["phone"],
        rating: json["rating"],
        discount: json["discount"] ?? 0,
        status: json["status"],
        saleRepImagePath: json["saleRepImagePath"],
        saleRepImage: json["saleRepImage"],
      );

// Map<String, dynamic> toJson() => {
//       "email": email,
//       "password": password,
//       "roleId": roleId,
//       "bytefile": bytefile,
//       "id": id,
//       "firstName": firstName,
//       "lastName": lastName,
//       "state": state,
//       "city": city,
//       "address": address,
//       "location": location,
//       "phone": phone,
//       "rating": rating,
//       "discount": discount,
//       "status": status,
//       "saleRepImagePath": saleRepImagePath,
//       "saleRepImage": saleRepImage,
//     };
}
