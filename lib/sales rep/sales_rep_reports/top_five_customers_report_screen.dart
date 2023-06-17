import 'package:flutter/cupertino.dart';
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

    model = Provider.of<TopFiveCustomerProvider>(context, listen: false)
        .fiveCustomers!;
    setState(() {});
    CustomLoader.hideLoader(context);
  }

  List<TopFiveCustomersModel> model = [];
  bool _sortByAmount = false;
  bool _sortByOrder = false;

  void _filterItems() {
    setState(() {
      if (_sortByAmount) {
        model.sort((a, b) => b.totalGrandTotal!.compareTo(a.totalGrandTotal!));
      } else if (_sortByOrder) {
        model.sort((a, b) => b.totalOrders!.compareTo(a.totalOrders!));
      } else {
        // If no filter is selected, display items in their original order
        model.sort((a, b) => a.totalGrandTotal!.compareTo(b.totalGrandTotal!));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      topFiveCustomersHandler();
    });
  }

  bool isFilteredItems = false;
  String selectFilter = '';

  int? selectIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top Five Customers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor,
      ),
      body: model.isEmpty
          ? const Center(child: Text("No customer found "))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Filter by categotries"),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                isFilteredItems = !isFilteredItems;
                                setState(() {});
                              },
                              child: const Icon(CupertinoIcons.down_arrow))
                        ],
                      ),
                      const SizedBox(height: 5),
                      isFilteredItems == true
                          ? AnimatedPositioned(
                              duration: const Duration(seconds: 2),
                              // Set the desired duration for the animation
                              curve: Curves.easeInOutCubicEmphasized,
                              // Set the desired curve for the animation

                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: appColor)),
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      FilterWidget(
                                          color:
                                              selectIndex == 0 ? true : false,
                                          text: 'Orders',
                                          onTap: () {
                                            selectFilter = 'Orders';
                                            _sortByOrder = true;
                                            _sortByAmount = false;
                                            _filterItems();

                                            selectIndex = 0;
                                            setState(() {});
                                          }),
                                      const SizedBox(height: 5),
                                      const Divider(),
                                      const SizedBox(height: 5),
                                      FilterWidget(
                                          color:
                                              selectIndex == 1 ? true : false,
                                          text: 'Purchase Amount',
                                          onTap: () {
                                            selectIndex = 1;
                                            _sortByOrder = false;
                                            _sortByAmount = true;
                                            _filterItems();
                                            selectFilter = 'PurchasingOrders';

                                            setState(() {});
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
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
                              child: Center(child: Text('Total Purchases(\$)')),
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
                                    itemCount: model.length,
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
                                                      child: Text(model[index]
                                                          .firstName!))),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(model[index]
                                                      .totalOrders
                                                      .toString()),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(model[index]
                                                      .totalGrandTotal
                                                      .toString()),
                                                ),
                                              )),
                                            ],
                                          ),
                                          if (model.isNotEmpty &&
                                              index != model.length - 1)
                                            const Divider()
                                        ],
                                      );
                                    }))
                          ])
                        ],
                      ),
                      const SizedBox(height: 10),
                      SfCartesianChart(
                        title: ChartTitle(text: 'Top Five Customers Purchase'),
                        legend: Legend(isVisible: true),
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          StackedColumnSeries<TopFiveCustomersModel, String>(
                              dataSource: model,
                              xValueMapper: (TopFiveCustomersModel sales, _) =>
                                  sales.firstName,
                              yValueMapper: (TopFiveCustomersModel sales, _) =>
                                  selectFilter == 'Orders'
                                      ? sales.totalOrders
                                      : selectFilter == 'PurchasingOrders'
                                          ? sales.totalGrandTotal
                                          : sales.totalOrders,
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
  }
}

class FilterWidget extends StatefulWidget {
  bool color;
  Function()? onTap;
  String? text;

  FilterWidget({required this.color, this.text, this.onTap});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.onTap),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(
              seconds: 1,
            ),
            decoration: BoxDecoration(
                color: widget.color ? appColor : Colors.transparent,
                border:
                    Border.all(color: widget.color ? appColor : Colors.black),
                borderRadius: BorderRadius.circular(8)),
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 20),
          Text(
            widget.text!,
            style: TextStyle(
                color: widget.color == true ? appColor : Colors.black,
                fontWeight: widget.color == true ? FontWeight.bold : null),
          )
        ],
      ),
    );
  }
}
