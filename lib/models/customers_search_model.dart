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
        data!.add(new CustomersSearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['salon_Name'] = this.salonName;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['location'] = this.location;
    data['customerImagePath'] = this.customerImagePath;
    data['customerImage'] = this.customerImage;
    data['phone'] = this.phone;
    data['saleRepID'] = this.saleRepID;
    data['saleRep'] = this.saleRep;
    data['loginId'] = this.loginId;
    data['login'] = this.login;
    data['customerOrders'] = this.customerOrders;
    return data;
  }
}
