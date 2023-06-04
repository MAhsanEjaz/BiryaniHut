class TopCategoryModel {
  Data? data;
  int? statusCode;
  String? message;

  TopCategoryModel({this.data, this.statusCode, this.message});

  TopCategoryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Data {
  List<Datasets>? datasets;
  List<SalesTabularData>? salesTabularData;

  Data({this.datasets, this.salesTabularData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['datasets'] != null) {
      datasets = <Datasets>[];
      json['datasets'].forEach((v) {
        datasets!.add(Datasets.fromJson(v));
      });
    }
    if (json['salesTabularData'] != null) {
      salesTabularData = <SalesTabularData>[];
      json['salesTabularData'].forEach((v) {
        salesTabularData!.add(SalesTabularData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (datasets != null) {
      data['datasets'] = datasets!.map((v) => v.toJson()).toList();
    }
    if (salesTabularData != null) {
      data['salesTabularData'] =
          salesTabularData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datasets {
  int? hour;
  String? categoryName;
  double? sale;

  Datasets({

    this.hour,
    this.categoryName,
    this.sale
  });

  Datasets.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    categoryName = json['categoryName'];
    sale = (json['sale'] as double?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hour'] = hour;
    data['categoryName'] = categoryName;
    data['sale'] = sale;
    return data;
  }
}
class SalesTabularData {
  String? categoryName;

  int? quantitySold;
  double? grossSale;

  SalesTabularData({
    this.categoryName,
    this.quantitySold, this.grossSale
  });

  SalesTabularData.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    quantitySold = json['quantitySold'];
    grossSale = json['grossSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['quantitySold'] = quantitySold;
    data['grossSale'] = grossSale;
    return data;
  }
}
