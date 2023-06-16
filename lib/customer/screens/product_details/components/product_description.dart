import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/cust_favourites_product_provider.dart';
import 'package:shop_app/services/customer_favourtes_products_service.dart';
import 'package:shop_app/services/product_remove_favourite_service.dart';
import 'package:shop_app/size_config.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../models/products_model.dart';
import '../../../../services/add_to_favourite_service.dart';
import '../../../../storages/login_storage.dart';

class ProductDescription extends StatefulWidget {
  final bool isReseller;
  ProductData element;

  bool heartColor;

  ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
    required this.element,
    this.heartColor = true,
    required this.isReseller,
  }) : super(key: key);

  final ProductData product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  LoginStorage loginStorage = LoginStorage();

  DateTime currentDate = DateTime.now();
  bool isFav = false;
  bool showAllText = false;

  addToFavHandler() async {
    CustomLoader.showLoader(context: context);
    await AddToFavouriteService().addToFav(
        context: context,
        customerId: LoginStorage().getUserId(),
        productId: widget.product.productId,
        date: "$currentDate");

    CustomLoader.hideLoader(context);
  }

  _getCustFavProdHandler() async {
    CustomLoader.showLoader(context: context);
    await CustFavProductsService().getCustFavProd(
        context: context, customerId: LoginStorage().getUserId());
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    log("Length ${widget.product.discription.length}");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCustFavProdHandler();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustFavouritesProductsProvider>(
        builder: (context, data, _) {
          List<Widget> widgets = [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(
              widget.product.productName,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          if (!widget.isReseller)
            InkWell(
              onTap: widget.heartColor == true
                  ? () async {
                      CustomLoader.showLoader(context: context);
                      bool res = await DeleteFavouriteService()
                          .deleteFavouriteService(
                              context: context,
                              customerId: loginStorage.getUserId(),
                              productId: widget.product.productId);

                      await _getCustFavProdHandler();


                      if (res == true) {
                        showToast('Product removed from Favourites');
                      }

                      CustomLoader.hideLoader(context);
                    }
                  : () {
                      isFav = true;
                      isFav ? addToFavHandler() : null;
                      log("Is Fav $isFav");
                      setState(() {});
                    },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                  width: getProportionateScreenWidth(64),
                  decoration: const BoxDecoration(
                    color:
                        // product.isFavourite ? Color(0xFFFFE6E6) :
                        Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Heart Icon_2.svg",
                    color:
                        // product.isFavourite ? Color(0xFFFF4848) :
                        widget.heartColor == true
                            ? Colors.red[900]
                            : isFav
                                ? Colors.red
                                : const Color(0xFFDBDEE4),
                    height: getProportionateScreenWidth(16),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64),
            ),
            child: widget.product.discription.length > 200
                ? Text(
                    widget.product.discription.substring(
                        0,
                        showAllText == true
                            ? null
                            : widget.product.discription.length ~/ 4),
                  )
                : Text(widget.product.discription),
          ),

          widget.product.discription.length > 200
              ? InkWell(
                  onTap: () {
                    showAllText = !showAllText;
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(20),
                      right: getProportionateScreenWidth(64),
                    ),
                    child: Text(
                      showAllText ? "See Less Details" : "See More Details",
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ))
              : const SizedBox(),
          //    widget.product.discription.length>200?
          //    RichText(
          //        textAlign: TextAlign.justify,
          //        text: TextSpan(
          //          // widget.description.substring(0,showAllText==true?null:(widget.description.length/4).toInt())
          //            text: widget.product.discription.substring(
          //                0,
          //                showAllText == true
          //                    ? null
          //                    : (widget.product.discription.length / 4)
          //                    .toInt()),
          //            style: TextStyle(color: kPrimaryColor),
          //
          //            children: [
          //              TextSpan(
          //                recognizer: TapGestureRecognizer()
          //                  ..onTap = () {
          //                    showAllText = !showAllText;
          //                    setState(() {});
          //                  },
          //                text: showAllText == true ? "See Less Details" : "See More Details",
          // style: TextStyle(color: kPrimaryColor),
          //              )
          //            ])):SizedBox()
        ],
      );
    });
  }
}
