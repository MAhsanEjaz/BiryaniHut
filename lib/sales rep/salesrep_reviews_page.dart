import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/reviews_provider.dart';
import 'package:shop_app/services/reviews_service.dart';
import 'package:shop_app/storages/login_storage.dart';

import '../models/reviews_model.dart';

class SalesRepReviewsPage extends StatefulWidget {
  const SalesRepReviewsPage({Key? key}) : super(key: key);

  @override
  State<SalesRepReviewsPage> createState() => _SalesRepReviewsPageState();
}

class _SalesRepReviewsPageState extends State<SalesRepReviewsPage> {
  reviewsHandler() async {
    CustomLoader.showLoader(context: context);
    await ReviewsService()
        .getReviews(context: context, saleRapId: LoginStorage().getUserId());
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reviewsHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          "Reviews & Comments",
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ReviewsProvider>(builder: (context, review, _) {
                  return review.reviews!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: review.reviews!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              elevation: 10.0,
                              shape: rectangleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "${review.reviews![index].customerName}",
                                          style: idStyle,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        const Spacer(),
                                        Text(
                                          getDate(review
                                                  .reviews![index].ratingDate) +
                                              " " +
                                              getTime(review
                                                  .reviews![index].ratingDate),
                                          style: dateStyle,
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: RatingBarIndicator(
                                          itemSize: 15.0,
                                          rating:
                                              review.reviews![index].rating!,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              )),
                                    ),
                                    Text(
                                      "${review.reviews![index].customerComment}",
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "No Review yet !",
                            style: dateStyle,
                          ),
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
