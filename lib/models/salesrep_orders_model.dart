class SaleRepOrdersModel {
  List<SaleRapOrdersList>? data;
  int? statusCode;
  String? message;

  SaleRepOrdersModel({this.data, this.statusCode, this.message});

  SaleRepOrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SaleRapOrdersList>[];
      json['data'].forEach((v) {
        data!.add(SaleRapOrdersList.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = statusCode;
    data['message'] = message;
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
        orderProducts!.add(OrderProducts.fromJson(v));
      });
    }
    if (json['orderPayment'] != null) {
      orderPayment = <OrderPayment>[];
      json['orderPayment'].forEach((v) {
        orderPayment!.add(OrderPayment.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['salon_Name'] = salonName;
    data['address'] = address;
    data['location'] = location;
    data['customerImagePath'] = customerImagePath;
    data['customerImage'] = customerImage;
    data['saleRepName'] = saleRepName;
    data['saleRepId'] = saleRepId;
    data['rating'] = rating;
    if (orderProducts != null) {
      data['orderProducts'] = orderProducts!.map((v) => v.toJson()).toList();
    }
    if (orderPayment != null) {
      data['orderPayment'] = orderPayment!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = orderId;
    data['totalPrice'] = totalPrice;
    data['discount'] = discount;
    data['grandTotal'] = grandTotal;
    data['dateTime'] = dateTime;
    data['status'] = status;
    data['orderPendingPayment'] = orderPendingPayment;
    data['orderPaidAmount'] = orderPaidAmount;
    data['previousBalance'] = previousBalance;
    data['totalBalance'] = totalBalance;
    data['completeOrderDateTime'] = completeOrderDateTime;
    data['orderBy'] = orderBy;
    data['customerId'] = customerId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalCost'] = totalCost;
    data['discount'] = discount;
    data['totalPrice'] = totalPrice;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['productImagePath'] = productImagePath;
    data['productImage'] = productImage;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paymentMethod'] = paymentMethod;
    data['paymentAmount'] = paymentAmount;
    data['chequeNumber'] = chequeNumber;
    return data;
  }
}
