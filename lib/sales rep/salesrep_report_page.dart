import 'package:flutter/material.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/sales_rep_payment_aging_report.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/salesrep_orders_aging_report.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/salesrep_payments_report_page.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/salesrep_order_report_page.dart';
import 'package:shop_app/sales%20rep/sales_rep_reports/top_five_customers_report_screen.dart';

import '../components/salesrep_report_custom_widget.dart';
import '../constants.dart';
import '../size_config.dart';
import 'timelines/top_five_products_screen.dart';

class SaleRepReportPage extends StatefulWidget {
  const SaleRepReportPage({Key? key}) : super(key: key);

  @override
  State<SaleRepReportPage> createState() => _SaleRepReportPageState();
}

class _SaleRepReportPageState extends State<SaleRepReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme,
        backgroundColor: appColor,
        title: const Text(
          "Reports",
          style: appbarTextStye,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/images/5. Order.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderReportPage()));
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/images/6. Payments.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SalesrepPaymentsReportPage()));
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/images/4. Order Aging.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SalesrepOrderAgingReportPage()));
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/images/payment_aging.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SalesRepPaymentAgingReport()));
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/svg/topfive.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TopFiveProductsPage()));
                    },
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SalesRepReportCustomWidget(
                    reportImage: 'assets/svg/topfivecustomers.svg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const TopFiveCustomersReportScreen()));
                    },
                  ),


                  // InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const CategoriesReportsPage()));
                  //     },
                  //     child: const Text("Categories report")),
                  // SizedBox(height: SizeConfig.screenHeight * 0.02),
                  // InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const TopFiveProductsPage()));
                  //     },
                  //     child: const Text("Top five products report")),
                ],
              ),  
            ),
          ),
        ),
      ),
    );
  }
}
