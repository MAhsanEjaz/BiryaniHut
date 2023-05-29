class ReviewsModel {
  List<ReviewsList>? data;
  int? statusCode;
  String? message;

  ReviewsModel({this.data, this.statusCode, this.message});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReviewsList>[];
      json['data'].forEach((v) {
        data!.add(new ReviewsList.fromJson(v));
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

class ReviewsList {
  String? customerName;
  String? customerComment;
  String? customerImageUrl;
  String? ratingDate;
  double? orderAmount;
  double? rating;
  double? overAllRating;

  ReviewsList(
      {this.customerName,
      this.customerComment,
      this.customerImageUrl,
      this.ratingDate,
      this.orderAmount,
      this.rating,
      this.overAllRating});

  ReviewsList.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    customerComment = json['customerComment'];
    customerImageUrl = json['customerImageUrl'];
    ratingDate = json['ratingDate'];
    orderAmount = json['orderAmount'];
    rating = json['rating'];
    overAllRating = json['overAllRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['customerComment'] = this.customerComment;
    data['customerImageUrl'] = this.customerImageUrl;
    data['ratingDate'] = this.ratingDate;
    data['orderAmount'] = this.orderAmount;
    data['rating'] = this.rating;
    data['overAllRating'] = this.overAllRating;
    return data;
  }
}
