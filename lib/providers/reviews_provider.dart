
import 'package:flutter/material.dart';

import '../models/reviews_model.dart';

class ReviewsProvider extends ChangeNotifier{
  List<ReviewsList>? reviews=[];
  updateReviews({List<ReviewsList>? newReviews}){
    reviews=newReviews;
    notifyListeners();
  }
}