class AllCitiesModel {
  int? id;
  String? cityName;
  String? stateCode;

  AllCitiesModel({this.id, this.cityName, this.stateCode});

  AllCitiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['cityName'];
    stateCode = json['stateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cityName'] = this.cityName;
    data['stateCode'] = this.stateCode;
    return data;
  }
}
