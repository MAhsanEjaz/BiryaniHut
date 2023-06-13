class SalesrepDiscountModel {
  Data data;
  int statusCode;
  String message;

  SalesrepDiscountModel({
    required this.data,
    required this.statusCode,
    required this.message,
  });

  factory SalesrepDiscountModel.fromJson(Map<String, dynamic> json) =>
      SalesrepDiscountModel(
        data: Data.fromJson(json["data"]),
        statusCode: json["statusCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "statusCode": statusCode,
        "message": message,
      };
}

class Data {
  int id;
  int discount;
  String discountType;

  Data({
    required this.id,
    required this.discount,
    required this.discountType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        discount: json["discount"],
        discountType: json["discountType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "discount": discount,
        "discountType": discountType,
      };
}
