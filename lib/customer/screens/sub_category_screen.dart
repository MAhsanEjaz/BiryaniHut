import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/customer_products_widget.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/models/sub_category_model.dart';
import 'package:shop_app/providers/sub_category_provider.dart';

import 'package:shop_app/services/sub_category_service.dart';

class SubCategoryScreen extends StatefulWidget {
  int productId;
  String categoryName;

  SubCategoryScreen({required this.productId, required this.categoryName});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  List<ProductData> model = [];

  subCategoryHandler() async {
    CustomLoader.showLoader(context: context);
    await SubCategoryService()
        .subCategoryService(context: context, productId: widget.productId);

    CustomLoader.hideLoader(context);

    model = Provider.of<SubCategoryProvider>(context, listen: false).model!;

    setState(() {});

    print('SubCategory----->${model}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subCategoryHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: model.isEmpty
          ? Center(child: Text('Not Found'))
          : SafeArea(
              child: Column(
                children: [
                  Wrap(
                    children: [
                      for (var products in model)
                        CustomerProductsWidget(
                          isReseller: false,
                          productData: products,
                        )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
