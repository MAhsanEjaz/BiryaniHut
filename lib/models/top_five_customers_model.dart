class TopFiveCustomersModel {
  int? id;
  String? firstName;
  int? totalOrders;

  TopFiveCustomersModel({this.id, this.firstName, this.totalOrders});

  TopFiveCustomersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    totalOrders = json['totalOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['totalOrders'] = this.totalOrders;
    return data;
  }
}
