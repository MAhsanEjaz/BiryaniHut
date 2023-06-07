class CustomerProfileModel {
  Data? data;
  int statusCode;
  String message;

  CustomerProfileModel({
    this.data,
    required this.statusCode,
    required this.message,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) =>
      CustomerProfileModel(
        data: Data.fromJson(json["data"]),
        statusCode: json["statusCode"],
        message: json["message"],
      );
}

class Data {
  int id;
  String firstName;
  String lastName;
  String salonName;
  String state;
  String city;
  String address;
  String? location;
  String? customerImagePath;
  dynamic customerImage;
  String phone;
  num accountBalance;
  int saleRepId;
  SaleRep? saleRep;
  int loginId;
  dynamic deleteStatus;
  dynamic deletedDate;
  dynamic deletedBy;

  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.salonName,
    required this.state,
    required this.city,
    required this.address,
    required this.location,
    required this.customerImagePath,
    this.customerImage,
    required this.phone,
    required this.accountBalance,
    required this.saleRepId,
    this.saleRep,
    required this.loginId,
    this.deleteStatus,
    this.deletedDate,
    this.deletedBy,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        salonName: json["salon_Name"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        location: json["location"],
        customerImagePath: json["customerImagePath"],
        customerImage: json["customerImage"],
        phone: json["phone"],
        accountBalance: json["accountBalance"],
        saleRepId: json["saleRepID"],
        saleRep: SaleRep.fromJson(json["saleRep"]),
        loginId: json["loginId"],
        deleteStatus: json["deleteStatus"],
        deletedDate: json["deletedDate"],
        deletedBy: json["deletedBy"],
      );
}

class SaleRep {
  int id;
  String firstName;
  String lastName;
  String saleRepImagePath;

  SaleRep({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.saleRepImagePath,
  });

  factory SaleRep.fromJson(Map<String, dynamic> json) => SaleRep(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        saleRepImagePath: json["saleRepImagePath"],
      );
}
