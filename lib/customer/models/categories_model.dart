class CustomerAllCategoriesModel {
  List<CategoriesList>? data;
  int? statusCode;
  String? message;

  CustomerAllCategoriesModel({this.data, this.statusCode, this.message});

  CustomerAllCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoriesList>[];
      json['data'].forEach((v) {
        data!.add(new CategoriesList.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class CategoriesList {
  int? categoryId;
  String? categoryName;
  String? description;
  String? categoryImage;

  CategoriesList(
      {this.categoryId,
        this.categoryName,
        this.description,
        this.categoryImage});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    categoryImage = json['categoryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['description'] = this.description;
    data['categoryImage'] = this.categoryImage;
    return data;
  }
}
