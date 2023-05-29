class OrderReportDetailsModel {
  OrderReports? data;
  int? statusCode;
  String? message;

  OrderReportDetailsModel({this.data, this.statusCode, this.message});

  OrderReportDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? OrderReports.fromJson(json['data']) : null;
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

class OrderReports {
  OrderReports({
    required this.firstName,
    required this.lastName,
    required this.salonName,
    required this.address,
    required this.location,
    required this.customerImagePath,
    this.customerImage,
    required this.saleRepName,
    required this.rating,
    required this.orderProducts,
    required this.orderPayment,
    required this.orderId,
    required this.totalPrice,
    required this.discount,
    required this.grandTotal,
    required this.dateTime,
    required this.status,
    required this.orderPendingPayment,
    required this.orderPaidAmount,
    required this.totalBalance,
    required this.orderBy,
    required this.previousBalance,
  });

  String firstName;
  String lastName;
  String salonName;
  String address;
  String location;
  String? customerImagePath;
  String? customerImage;
  String saleRepName;
  num rating;
  List<OrderProduct> orderProducts;
  List<OrderPayment> orderPayment;
  int orderId;
  num totalPrice;
  num discount;
  num grandTotal;
  String dateTime;
  String status;
  num orderPendingPayment;
  num orderPaidAmount;
  num orderBy;
  num totalBalance;
  num previousBalance;

  factory OrderReports.fromJson(Map<String, dynamic> json) => OrderReports(
        firstName: json["firstName"],
        lastName: json["lastName"],
        salonName: json["salon_Name"],
        address: json["address"],
        location: json["location"],
        customerImagePath: json["customerImagePath"] ?? "",
        customerImage: json["customerImage"] ?? "",
        saleRepName: json["saleRepName"],
        rating: json["rating"],
        orderProducts: List<OrderProduct>.from(
            json["orderProducts"].map((x) => OrderProduct.fromJson(x))),
        orderPayment: List<OrderPayment>.from(
            json["orderPayment"].map((x) => OrderPayment.fromJson(x))),
        orderId: json["orderId"],
        totalPrice: json["totalPrice"],
        discount: json["discount"],
        grandTotal: json["grandTotal"],
        dateTime: json["dateTime"],
        status: json["status"],
        orderPendingPayment: json["orderPendingPayment"],
        orderPaidAmount: json["orderPaidAmount"],
        orderBy: json["orderBy"],
        totalBalance: json["totalBalance"],
        previousBalance: json["previousBalance"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "salon_Name": salonName,
        "address": address,
        "location": location,
        "customerImagePath": customerImagePath,
        "customerImage": customerImage,
        "saleRepName": saleRepName,
        "rating": rating,
        "orderProducts":
            List<dynamic>.from(orderProducts.map((x) => x.toJson())),
        "orderPayment": List<dynamic>.from(orderPayment.map((x) => x.toJson())),
        "orderId": orderId,
        "totalPrice": totalPrice,
        "discount": discount,
        "grandTotal": grandTotal,
        "dateTime": dateTime,
        "status": status,
        "orderPendingPayment": orderPendingPayment,
        "orderPaidAmount": orderPaidAmount,
        "totalBalance": totalBalance,
        "previousBalance": previousBalance,
        "orderBy": orderBy,
      };
}

class OrderPayment {
  OrderPayment({
    required this.id,
    required this.paymentMethod,
    required this.paymentAmount,
    this.orderId,
  });

  num id;
  String paymentMethod;
  num paymentAmount;
  num? orderId;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
        id: json["id"],
        paymentMethod: json["paymentMethod"],
        paymentAmount: json["paymentAmount"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentMethod": paymentMethod,
        "paymentAmount": paymentAmount,
        "orderId": orderId,
      };
}

class OrderProduct {
  OrderProduct({
    required this.productId,
    required this.price,
    required this.quantity,
    required this.totalCost,
    required this.discount,
    required this.totalPrice,
    required this.productName,
    this.productDescription,
    this.productImagePath,
    this.productImage,
  });

  num productId;
  num price;
  num quantity;
  num totalCost;
  num discount;
  num totalPrice;
  String productName;
  String? productDescription;
  String? productImagePath = "";
  String? productImage;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        productId: json["productId"],
        price: json["price"] ?? 0,
        quantity: json["quantity"] ?? 0,
        totalCost: json["totalCost"],
        discount: json["discount"] ?? 0,
        totalPrice: json["totalPrice"] ?? 0,
        productName: json["productName"],
        productDescription: json["productDescription"] ?? "",
        productImagePath: json["productImagePath"] ?? "",
        productImage: json["productImage"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "price": price,
        "quantity": quantity,
        "totalCost": totalCost,
        "discount": discount,
        "totalPrice": totalPrice,
        "productName": productName,
        "productDescription": productDescription,
        "productImagePath": productImagePath,
        "productImage": productImage,
      };
}
