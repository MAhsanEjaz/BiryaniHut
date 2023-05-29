class SaleRepOrdersModel {
  List<SaleRapOrdersList>? data;
  int? statusCode;
  String? message;

  SaleRepOrdersModel({this.data, this.statusCode, this.message});

  SaleRepOrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SaleRapOrdersList>[];
      json['data'].forEach((v) {
        data!.add(new SaleRapOrdersList.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class SaleRapOrdersList {
  String? firstName;
  String? lastName;
  String? salonName;
  String? address;
  String? location;
  String? customerImagePath;
  String? customerImage;
  String? saleRepName;
  int? saleRepId;
  num? rating;
  List<OrderProducts>? orderProducts;
  List<OrderPayment>? orderPayment;
  int? orderId;
  double? totalPrice;
  num? discount;
  double? grandTotal;
  String? dateTime;
  String? status;
  double? orderPendingPayment;
  num? orderPaidAmount;
  double? previousBalance;
  double? totalBalance;
  Null? completeOrderDateTime;
  int? orderBy;
  int? customerId;

  SaleRapOrdersList(
      {this.firstName,
        this.lastName,
        this.salonName,
        this.address,
        this.location,
        this.customerImagePath,
        this.customerImage,
        this.saleRepName,
        this.saleRepId,
        this.rating,
        this.orderProducts,
        this.orderPayment,
        this.orderId,
        this.totalPrice,
        this.discount,
        this.grandTotal,
        this.dateTime,
        this.status,
        this.orderPendingPayment,
        this.orderPaidAmount,
        this.previousBalance,
        this.totalBalance,
        this.completeOrderDateTime,
        this.orderBy,
        this.customerId});

  SaleRapOrdersList.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    salonName = json['salon_Name'];
    address = json['address'];
    location = json['location'];
    customerImagePath = json['customerImagePath'];
    customerImage = json['customerImage'];
    saleRepName = json['saleRepName'];
    saleRepId = json['saleRepId'];
    rating = json['rating'];
    if (json['orderProducts'] != null) {
      orderProducts = <OrderProducts>[];
      json['orderProducts'].forEach((v) {
        orderProducts!.add(new OrderProducts.fromJson(v));
      });
    }
    if (json['orderPayment'] != null) {
      orderPayment = <OrderPayment>[];
      json['orderPayment'].forEach((v) {
        orderPayment!.add(new OrderPayment.fromJson(v));
      });
    }
    orderId = json['orderId'];
    totalPrice = json['totalPrice'];
    discount = json['discount'];
    grandTotal = json['grandTotal'];
    dateTime = json['dateTime'];
    status = json['status'];
    orderPendingPayment = json['orderPendingPayment'];
    orderPaidAmount = json['orderPaidAmount'];
    previousBalance = json['previousBalance'];
    totalBalance = json['totalBalance'];
    completeOrderDateTime = json['completeOrderDateTime'];
    orderBy = json['orderBy'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['salon_Name'] = this.salonName;
    data['address'] = this.address;
    data['location'] = this.location;
    data['customerImagePath'] = this.customerImagePath;
    data['customerImage'] = this.customerImage;
    data['saleRepName'] = this.saleRepName;
    data['saleRepId'] = this.saleRepId;
    data['rating'] = this.rating;
    if (this.orderProducts != null) {
      data['orderProducts'] =
          this.orderProducts!.map((v) => v.toJson()).toList();
    }
    if (this.orderPayment != null) {
      data['orderPayment'] = this.orderPayment!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = this.orderId;
    data['totalPrice'] = this.totalPrice;
    data['discount'] = this.discount;
    data['grandTotal'] = this.grandTotal;
    data['dateTime'] = this.dateTime;
    data['status'] = this.status;
    data['orderPendingPayment'] = this.orderPendingPayment;
    data['orderPaidAmount'] = this.orderPaidAmount;
    data['previousBalance'] = this.previousBalance;
    data['totalBalance'] = this.totalBalance;
    data['completeOrderDateTime'] = this.completeOrderDateTime;
    data['orderBy'] = this.orderBy;
    data['customerId'] = this.customerId;
    return data;
  }
}

class OrderProducts {
  int? productId;
  double? price;
  int? quantity;
  double? totalCost;
  num? discount;
  double? totalPrice;
  String? productName;
  String? productDescription;
  String? productImagePath;
  String? productImage;

  OrderProducts(
      {this.productId,
        this.price,
        this.quantity,
        this.totalCost,
        this.discount,
        this.totalPrice,
        this.productName,
        this.productDescription,
        this.productImagePath,
        this.productImage});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    price = json['price'];
    quantity = json['quantity'];
    totalCost = json['totalCost'];
    discount = json['discount'];
    totalPrice = json['totalPrice'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productImagePath = json['productImagePath'];
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['totalCost'] = this.totalCost;
    data['discount'] = this.discount;
    data['totalPrice'] = this.totalPrice;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['productImagePath'] = this.productImagePath;
    data['productImage'] = this.productImage;
    return data;
  }
}

class OrderPayment {
  int? id;
  String? paymentMethod;
  num? paymentAmount;
  String? chequeNumber;

  OrderPayment(
      {this.id, this.paymentMethod, this.paymentAmount, this.chequeNumber});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['paymentMethod'];
    paymentAmount = json['paymentAmount'];
    chequeNumber = json['chequeNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentMethod'] = this.paymentMethod;
    data['paymentAmount'] = this.paymentAmount;
    data['chequeNumber'] = this.chequeNumber;
    return data;
  }
}
