class CommonRespnceModel {
  CommonRespnceModel({
    required this.statusCode,
    required this.message,
  });

  int statusCode;
  String message;

  factory CommonRespnceModel.fromJson(Map<String, dynamic> json) =>
      CommonRespnceModel(
        statusCode: json["statusCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
      };
}
