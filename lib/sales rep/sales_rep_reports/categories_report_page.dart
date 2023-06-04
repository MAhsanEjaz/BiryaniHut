import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/providers/cost_of_good_sale_provider.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/good_sales_pdf_service.dart';
import 'package:shop_app/services/good_sales_services.dart';
import 'package:shop_app/size_config.dart';

class CategoriesReportsPage extends StatefulWidget {
  const CategoriesReportsPage({Key? key}) : super(key: key);

  @override
  State<CategoriesReportsPage> createState() => _CategoriesReportsPageState();
}

class _CategoriesReportsPageState extends State<CategoriesReportsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCategoriesHandler();
    });
  }

  void getCategoriesHandler() async {
    CustomLoader.showLoader(context: context);
    await CostOfGoodSalesService().goodSalesServices(context: context);
    CustomLoader.hideLoader(context);
  }

  GoodSalePdfService goodSalePdfService = GoodSalePdfService();

  @override
  Widget build(BuildContext context) {
    return Consumer<CostOfGooddSaleProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: const Text(
            "Categories Report",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: Cross,

            children: [
              ListTile(
                leading: const Text("Cost of Goods Sold"),
                trailing: Text(data.saleProvider![0].cost.toString()),
              ),
              ListTile(
                leading: const Text("Total Revenue"),
                trailing: Text(data.saleProvider![0].revenue.toString()),
              ),
              //  ListTile(
              //   leading: Text("Profit"),
              //   trailing: Text("${data.saleProvider![0].}"),
              // ),
              //  ListTile(
              //   leading: Text("Profit Margin"),
              //   trailing: Text("${data.saleProvider![0].cost.toString()}"),
              // ),
              const Divider(),
              Table(
                border: TableBorder.all(color: Colors.black26, width: 1.5),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: const [
                  TableRow(children: [
                    Text(
                      'Sr',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Name',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Cost',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Revenue',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Profit Margin',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ],
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Table(
                  border: TableBorder.all(color: Colors.black26, width: 1.5),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      // custList.isEmpty
                      // ?
                      if (data.saleProvider!.isEmpty)
                        const Text("Category report empty")
                      else
                        TableCell(
                            child: ListView.builder(
                                itemCount: data.saleProvider!.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              // flex:2,
                                              child: Text(
                                            '${index + 1}',
                                            style: tableStyle,
                                            textAlign: TextAlign.center,
                                          )),
                                          Expanded(
                                              // flex:2,
                                              child: Text(
                                            '${data.saleProvider![index].productName}',
                                            style: tableStyle,
                                            textAlign: TextAlign.center,
                                          )),
                                          Expanded(
                                              // flex:3,
                                              child: Text(
                                            data.saleProvider![index].cost
                                                .toString(),
                                            style: tableStyle,
                                            textAlign: TextAlign.center,
                                          )),
                                          Expanded(
                                              // flex:2,
                                              child: Text(
                                            data.saleProvider![index].revenue
                                                .toString(),
                                            style: tableStyle,
                                            textAlign: TextAlign.center,
                                          )),
                                          const Expanded(
                                              // flex:2,
                                              child: Text(
                                            '11',
                                            // getDate(order.dateTime),
                                            style: tableStyle,
                                            textAlign: TextAlign.center,
                                          )),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      if (data.saleProvider != null &&
                                          data.saleProvider!.isNotEmpty &&
                                          index !=
                                              data.saleProvider!.length - 1)
                                        const Divider()
                                    ],
                                  );
                                }))
                    ])
                  ],
                ),
              )
            ],
          ),
        )),
        bottomNavigationBar: Container(
          height: kToolbarHeight * 1.0,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: kSecondaryColor, width: 1.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultButton(
                  height: SizeConfig.screenHeight * 0.05,
                  width: SizeConfig.screenWidth * 0.5,
                  text: "Print Report",
                  press: () async {
                    final myData = await goodSalePdfService.createReport(
                        context: context, saleCustomer: data.saleProvider);
                    int number = 0;
                    goodSalePdfService.savePdfFile('number', myData);
                    number++;
                  })
            ],
          ),
        ),
      );
    });
  }
}
