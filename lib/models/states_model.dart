class AllStatesModel {
  int? id;
  String? stateName;
  String? stateCode;

  AllStatesModel({this.id, this.stateName, this.stateCode});

  AllStatesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateName = json['stateName'];
    stateCode = json['stateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stateName'] = this.stateName;
    data['stateCode'] = this.stateCode;
    return data;
  }
}
