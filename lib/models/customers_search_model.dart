class CustomersSearchModel {
  int? status;
  String? message;
  List<CustomersSearchList>? data;

  CustomersSearchModel({this.status, this.message, this.data});

  CustomersSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomersSearchList>[];
      json['data'].forEach((v) {
        data!.add(CustomersSearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomersSearchList {
  int? id;
  String? firstName;
  String? lastName;
  String? salonName;
  String? state;
  String? city;
  String? address;
  String? location;
  String? customerImagePath;
  String? customerImage;
  String? phone;
  int? saleRepID;
  String? saleRep;
  int? loginId;
  bool? login;
  String? customerOrders;

  CustomersSearchList(
      {this.id,
      this.firstName,
      this.lastName,
      this.salonName,
      this.state,
      this.city,
      this.address,
      this.location,
      this.customerImagePath,
      this.customerImage,
      this.phone,
      this.saleRepID,
      this.saleRep,
      this.loginId,
      this.login,
      this.customerOrders});

  CustomersSearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    salonName = json['salon_Name'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    location = json['location'];
    customerImagePath = json['customerImagePath'];
    customerImage = json['customerImage'];
    phone = json['phone'];
    saleRepID = json['saleRepID'];
    saleRep = json['saleRep'];
    loginId = json['loginId'];
    login = json['login'];
    customerOrders = json['customerOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['salon_Name'] = salonName;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['location'] = location;
    data['customerImagePath'] = customerImagePath;
    data['customerImage'] = customerImage;
    data['phone'] = phone;
    data['saleRepID'] = saleRepID;
    data['saleRep'] = saleRep;
    data['loginId'] = loginId;
    data['login'] = login;
    data['customerOrders'] = customerOrders;
    return data;
  }
}
