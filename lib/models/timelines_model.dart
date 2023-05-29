class TimeLinesModel {
  int? status;
  String? message;
  List<TimeLines>? data;

  TimeLinesModel({this.status, this.message, this.data});

  TimeLinesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TimeLines>[];
      json['data'].forEach((v) {
        data!.add(new TimeLines.fromJson(v));
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

class TimeLines {
  int? broadId;
  String? selectState;
  String? selectCity;
  bool? allSaleRep;
  bool? allCustomers;
  String? title;
  String? description;
  String? imagePath;
  String? image;
  int? saleRepId;
  int? customerId;

  TimeLines(
      {this.broadId,
        this.selectState,
        this.selectCity,
        this.allSaleRep,
        this.allCustomers,
        this.title,
        this.description,
        this.imagePath,
        this.image,
        this.saleRepId,
        this.customerId});

  TimeLines.fromJson(Map<String, dynamic> json) {
    broadId = json['broadId'];
    selectState = json['selectState'];
    selectCity = json['selectCity'];
    allSaleRep = json['allSaleRep'];
    allCustomers = json['allCustomers'];
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
    image = json['image'];
    saleRepId = json['saleRepId'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broadId'] = this.broadId;
    data['selectState'] = this.selectState;
    data['selectCity'] = this.selectCity;
    data['allSaleRep'] = this.allSaleRep;
    data['allCustomers'] = this.allCustomers;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imagePath'] = this.imagePath;
    data['image'] = this.image;
    data['saleRepId'] = this.saleRepId;
    data['customerId'] = this.customerId;
    return data;
  }
}
