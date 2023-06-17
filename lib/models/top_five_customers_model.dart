class TopFiveCustomersModel {
  int? id;
  String? firstName;
  num? totalOrders;
  num? totalGrandTotal;

  TopFiveCustomersModel(
      {this.id, this.firstName, this.totalOrders, this.totalGrandTotal});

  TopFiveCustomersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    totalOrders = json['totalOrders'];
    totalGrandTotal = json['totalGrandTotal'];
  }
}
