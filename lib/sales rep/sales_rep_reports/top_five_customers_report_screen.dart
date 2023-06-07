import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/top_five_customers_model.dart';
import 'package:shop_app/providers/top_five_customers_provider.dart';
import 'package:shop_app/providers/top_five_products_provider.dart';
import 'package:shop_app/services/top_five_customers_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopFiveCustomersReportScreen extends StatefulWidget {
  const TopFiveCustomersReportScreen({Key? key}) : super(key: key);

  @override
  State<TopFiveCustomersReportScreen> createState() =>
      _TopFiveCustomersReportScreenState();
}

class _TopFiveCustomersReportScreenState
    extends State<TopFiveCustomersReportScreen> {
  topFiveCustomersHandler() async {
    CustomLoader.showLoader(context: context);
    await TopFiveCustomersService().topFiveCustomerService(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      topFiveCustomersHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopFiveCustomerProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
        ),
        body: data.fiveCustomers!.isEmpty
            ? const Center(child: Text("No customer found "))
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder.all(width: 1.6),
                          children: const [
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Sr')),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Customer Name')),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Total orders')),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: Text('Total Purchases(\$)')),
                              ),
                            ])
                          ],
                        ),
                        Table(
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(children: [
                              TableCell(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data.fiveCustomers!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child:
                                                          Text('${index + 1}')),
                                                )),
                                                Expanded(
                                                    child: Center(
                                                        child: Text(data
                                                            .fiveCustomers![
                                                                index]
                                                            .firstName!))),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(data
                                                        .fiveCustomers![index]
                                                        .totalOrders
                                                        .toString()),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(data
                                                        .fiveCustomers![index]
                                                        .totalGrandTotal
                                                        .toString()),
                                                  ),
                                                )),
                                              ],
                                            ),
                                            if (data.fiveCustomers != null &&
                                                data.fiveCustomers!
                                                    .isNotEmpty &&
                                                index !=
                                                    data.fiveCustomers!.length -
                                                        1)
                                              const Divider()
                                          ],
                                        );
                                      }))
                            ])
                          ],
                        ),
                        for (int i = 0; i < data.fiveCustomers!.length; i++)
                          const SizedBox(height: 10),
                        SfCartesianChart(
                          title: ChartTitle(text: 'Top Five Customers Sale'),
                          legend: Legend(isVisible: true),
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            StackedColumnSeries<TopFiveCustomersModel, String>(
                                dataSource: data.fiveCustomers!,
                                xValueMapper:
                                    (TopFiveCustomersModel sales, _) =>
                                        sales.firstName,
                                yValueMapper:
                                    (TopFiveCustomersModel sales, _) =>
                                        sales.totalOrders,
                                name: 'Customers',
                                borderRadius: BorderRadius.circular(10),
                                trackBorderColor: Colors.pink[100]),
                          ],
                          tooltipBehavior: TooltipBehavior(enable: true),
                          enableAxisAnimation: true,
                          // isTransposed: true,
                          trackballBehavior: TrackballBehavior(
                              activationMode: ActivationMode.doubleTap),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
