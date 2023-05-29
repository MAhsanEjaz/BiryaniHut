import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_search_provider.dart';
import '../../../../components/customer_products_widget.dart';
import '../../../../constants.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../services/products_search_service.dart';

class ProductSearchScreen extends StatefulWidget {
  final String prodName;
  final bool isReseller;
  const ProductSearchScreen(
      {Key? key, required this.prodName, required this.isReseller})
      : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  prodSearchHandler() async {
    CustomLoader.showLoader(context: context);
    await ProductsSearchService()
        .searchProd(context: context, prodName: widget.prodName);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      prodSearchHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: Text(
          widget.prodName,
          style: appbarTextStye,
        ),
      ),
      body: Consumer<ProductSearchProvider>(
        builder: (context, search, _) {
          List<Widget> widgets = [];
          search.prodSearch != null
              ? search.prodSearch!.forEach((element) {
                  widgets.add(CustomerProductsWidget(
                      isReseller: widget.isReseller, productData: element));
                })
              : Center(
                  child: Text(
                  "No Product Exists",
                  style: dateStyle,
                ));
          return Wrap(
            children: widgets,
          );
        },
      ),
    );
  }
}
