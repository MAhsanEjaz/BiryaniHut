import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/top_five_product_model.dart';
import 'package:shop_app/providers/top_five_products_provider.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/top_five_products_report.dart';
import 'package:shop_app/services/top_five_product_service.dart';
import 'package:shop_app/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopFiveProductsPage extends StatefulWidget {
  const TopFiveProductsPage({Key? key}) : super(key: key);

  @override
  State<TopFiveProductsPage> createState() => _TopFiveProductsPageState();
}

class _TopFiveProductsPageState extends State<TopFiveProductsPage> {
  topFiveProductHandler() async {
    CustomLoader.showLoader(context: context);

    await TopFiveProductsService().topFIveProductsService(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      topFiveProductHandler();
    });
  }

  TopFivePdfService topFivePdfService = TopFivePdfService();

  @override
  Widget build(BuildContext context) {
    return Consumer<TopFiveProductProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: AppBar(backgroundColor: appColor),
        body: data.topProducts!.isEmpty
            ? Center(child: Text("No product found"))
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.all(width: 1.5),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: const [
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("Sr")),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("Product Name")),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("Total Orders")),
                              ),
                            ]),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.all(
                                color: Colors.black26, width: 1.5),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(children: [
                                // custList.isEmpty
                                // ?
                                if (data.topProducts!.isEmpty)
                                  const Text("Category report empty")
                                else
                                  TableCell(
                                      child: ListView.builder(
                                          itemCount: data.topProducts!.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        // flex:2,
                                                        child: Text(
                                                      '${index + 1}',
                                                      style: tableStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                    Expanded(
                                                        // flex:2,
                                                        child: Text(
                                                      '${data.topProducts![index].productName}',
                                                      style: tableStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                    Expanded(
                                                        // flex:3,
                                                        child: Text(
                                                      data.topProducts![index]
                                                          .totalOrders
                                                          .toString(),
                                                      style: tableStyle,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                if (data.topProducts != null &&
                                                    data.topProducts!
                                                        .isNotEmpty &&
                                                    index !=
                                                        data.topProducts!
                                                                .length -
                                                            1)
                                                  const Divider()
                                              ],
                                            );
                                          }))
                              ])
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            arrangeByIndex: true,
                            autoScrollingMode: AutoScrollingMode.start,
                            majorGridLines: const MajorGridLines(),
                          ),
                          series: <ChartSeries>[
                            LineSeries<TopFiveProductsModel, String>(
                              dataSource: data.topProducts!,
                              xValueMapper: (TopFiveProductsModel sales, _) =>
                                  sales.productName,
                              yValueMapper: (TopFiveProductsModel sales, _) =>
                                  sales.totalOrders,
                            )
                          ],
                          annotations: [],
                          enableAxisAnimation: true,
                          enableMultiSelection: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    final myData = await topFivePdfService.createReport(
                        context: context, saleCustomer: data.topProducts);
                    int number = 0;
                    topFivePdfService.savePdfFile('number', myData);
                    number++;
                  })
            ],
          ),
        ),
      );
    });
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
