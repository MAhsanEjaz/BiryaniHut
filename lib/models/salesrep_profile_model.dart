class SalesrepProfileModel {
  Data data;
  String message;

  SalesrepProfileModel({
    required this.data,
    required this.message,
  });

  factory SalesrepProfileModel.fromJson(Map<String, dynamic> json) =>
      SalesrepProfileModel(
        data: Data.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class Data {
  String email;
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
        roleId: json["roleId"],
        bytefile: json["bytefile"],
        companyName: json["companyName"] ?? "",
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        state: json["state"] ?? "",
        city: json["city"],
        address: json["address"],
        location: json["location"] ?? "",
        phone: json["phone"],
        rating: json["rating"] ?? 5,
        discount: json["discount"] ?? 0,
        status: json["status"],
        saleRepImagePath: json["saleRepImagePath"],
        saleRepImage: json["saleRepImage"],
      );
}
