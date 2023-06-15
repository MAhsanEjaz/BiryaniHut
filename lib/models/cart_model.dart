import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.orderId,
    required this.totalPrice,
    required this.discount,
    required this.grandTotal,
    required this.dateTime,
    required this.status,
    required this.orderBy,
    required this.orderProducts,
    required this.customerId,
    required this.orderPayment,
    required this.orderPaidAmount,
    required this.orderPendingAmount,
    required this.remainingBalance,
    required this.totalBalance,
    required this.previousBalance,
    this.discountType,
  });

  num orderId;
  num totalPrice;
  num discount;
  String? discountType;
  num grandTotal;
  num orderPaidAmount;
  num orderPendingAmount;
  num remainingBalance;
  num totalBalance;
  num previousBalance;
  // num remainingBalance;
  DateTime dateTime;
  String status;
  num orderBy;
  List<CartItem> orderProducts;
  num customerId;
  List<OrderPayment> orderPayment;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        orderId: json["orderId"],
        totalPrice: json["totalPrice"],
        discount: json["discount"],
        grandTotal: json["grandTotal"],
        dateTime: DateTime.parse(json["dateTime"]),
        status: json["status"],
        orderBy: json["orderBy"],
        orderProducts: List<CartItem>.from(
            json["orderProducts"].map((x) => CartItem.fromJson(x))),
        customerId: json["customerId"],
        orderPayment: List<OrderPayment>.from(
            json["orderPayment"].map((x) => OrderPayment.fromJson(x))),
        orderPaidAmount: json["orderPaidAmount"],
        orderPendingAmount: json["orderPendingPayment"],
        remainingBalance: json["orderRemainingPayment"],
        totalBalance: json["totalBalance"],
        previousBalance: json["previousBalance"],
        discountType: json["DiscountType"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "totalPrice": totalPrice,
        "discount": discount,
        "grandTotal": grandTotal,
        "dateTime": dateTime.toIso8601String(),
        "status": status,
        "orderBy": orderBy,
        "orderProducts":
            List<dynamic>.from(orderProducts.map((x) => x.toJson())),
        "customerId": customerId,
        "orderPayment": List<dynamic>.from(orderPayment.map((x) => x.toJson())),
        "orderPaidAmount": orderPaidAmount,
        "orderPendingPayment": orderPendingAmount,
        "orderRemainingPayment": remainingBalance,
        "totalBalance": totalBalance,
        "previousBalance": previousBalance,
        "DiscountType": discountType
      };
}

class OrderPayment {
  OrderPayment({
    required this.paymentMethod,
    required this.paymentAmount,
    this.chequeNo,
    // this.chequeExpiryDate,
    // this.chequeFor
  });

  String paymentMethod;
  num paymentAmount;
  String? chequeNo;
  String? cashAppTransId;
  // String? chequeExpiryDate;
  // String? chequeFor;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
        paymentMethod: json["paymentMethod"],
        paymentAmount: json["paymentAmount"],
        chequeNo: json["chequeNumber"],
        // chequeFor: json["chequeFor"],
        // chequeExpiryDate: json["chequeExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "paymentMethod": paymentMethod,
        "paymentAmount": paymentAmount,
        // "chequeNumber": chequeNo,
        // "chequeExpiryDate": chequeExpiryDate,
        // "chequeFor": chequeFor,
      };
}

class CartItem {
  CartItem({
    required this.productId,
    required this.price,
    required this.quantity,
    required this.totalCost,
    required this.discount,
    required this.totalPrice,
    required this.productName,
    this.productDescription,
    required this.productImagePath,
    required this.productImage,
  });

  num productId;
  num price;
  int quantity;
  num totalCost;
  num discount;
  num totalPrice;
  String productName;
  String? productDescription;
  String productImagePath;
  String productImage;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json["productId"],
        price: json["price"],
        quantity: json["quantity"],
        totalCost: json["totalCost"],
        discount: json["discount"],
        totalPrice: json["totalPrice"],
        productName: json["productName"],
        productDescription: json["productDescription"],
        productImagePath: json["productImagePath"],
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
