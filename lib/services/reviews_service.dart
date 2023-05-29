import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/reviews_model.dart';
import 'package:shop_app/providers/reviews_provider.dart';

import '../constants.dart';
import '../helper/custom_get_request_service.dart';

const String reviewsUrl = "$apiBaseUrl/SaleRep/";

class ReviewsService {
  Future getReviews(
      {required BuildContext context, required int saleRapId}) async {
    try {
      var res = await CustomGetRequestService().httpGetRequest(
          context: context, url: reviewsUrl + "GetSaleRepReviews/$saleRapId");
      if (res != null) {
        ReviewsModel reviews = ReviewsModel.fromJson(res);
        Provider.of<ReviewsProvider>(context, listen: false)
            .updateReviews(newReviews: reviews.data);
        return true;
      }
    } catch (err) {
      print("Exception in Reviews & Comments Service $err");
      return null;
    }
  }
}
