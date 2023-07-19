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
  String? email;
  String? phone;
  List<OrderProducts>? orderProducts;
  List<OrderPayment>? orderPayment;
  int? orderId;
  num? totalPrice;
  num? discount;
  String? discountType;
  num? grandTotal;
  num? netTotal;
  String? dateTime;
  String? status;
  num? orderPendingPayment;
  num? orderPaidAmount;
  num? previousBalance;
  num? totalBalance;
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
      this.email,
      this.phone,
      this.orderProducts,
      this.orderPayment,
      this.orderId,
      this.totalPrice,
      this.discount,
      this.discountType,
      this.grandTotal,
      this.netTotal,
      this.dateTime,
      this.status,
      this.orderPendingPayment,
      this.orderPaidAmount,
      this.previousBalance,
      this.totalBalance,
      // this.completeOrderDateTime,
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
    email = json['email'];
    phone = json['phone'];
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
    discountType = json['discountType'];
    grandTotal = json['grandTotal'];
    netTotal = json['netTotal'];
    dateTime = json['dateTime'];
    status = json['status'];
    orderPendingPayment = json['orderPendingPayment'];
    orderPaidAmount = json['orderPaidAmount'];
    previousBalance = json['previousBalance'];
    totalBalance = json['totalBalance'];
    // completeOrderDateTime = json['completeOrderDateTime'];
    orderBy = json['orderBy'];
    customerId = json['customerId'];
  }
}

class OrderProducts {
  int? productId;
  num? salePrice;
  num? price;
  num? regularPrice;
  num? quantity;
  num? cost;
  num? totalCost;
  num? discount;
  num? totalPrice;
  String? productName;
  String? productDescription;
  String? productImagePath;
  String? productImage;

  OrderProducts(
      {this.productId,
      this.salePrice,
      this.price,
      this.regularPrice,
      this.quantity,
      this.cost,
      this.totalCost,
      this.discount,
      this.totalPrice,
      this.productName,
      this.productDescription,
      this.productImagePath,
      this.productImage});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    salePrice = json['salePrice'];
    price = json['price'];
    regularPrice = json['regularPrice'];
    quantity = json['quantity'];
    cost = json['cost'];
    totalCost = json['totalCost'];
    discount = json['discount'];
    totalPrice = json['totalPrice'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productImagePath = json['productImagePath'];
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productId'] = this.productId;
    data['salePrice'] = this.salePrice;
    data['price'] = this.price;
    data['regularPrice'] = this.regularPrice;
    data['quantity'] = this.quantity;
    data['cost'] = this.cost;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentMethod'] = this.paymentMethod;
    data['paymentAmount'] = this.paymentAmount;
    data['chequeNumber'] = this.chequeNumber;
    return data;
  }
}
