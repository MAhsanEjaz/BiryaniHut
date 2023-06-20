import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/customer/screens/splash/splash_screen.dart';
import 'package:shop_app/providers/account_balance_provider.dart';
import 'package:shop_app/providers/all_orders_provider.dart';
import 'package:shop_app/providers/counter_provider.dart';
import 'package:shop_app/providers/cust_favourites_product_provider.dart';
import 'package:shop_app/providers/customers_search_provider.dart';
import 'package:shop_app/providers/order_report_details_provider.dart';
import 'package:shop_app/providers/payment_get_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/providers/products_search_provider.dart';
import 'package:shop_app/providers/regitration_provider.dart';
import 'package:shop_app/providers/reseller_customer_provider.dart';
import 'package:shop_app/providers/reviews_provider.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';
import 'package:shop_app/providers/salerep_customer_order_aging_provider.dart';
import 'package:shop_app/providers/salerep_payments_report_provider.dart';
import 'package:shop_app/providers/salesrep_all_customer_payment_provider.dart';
import 'package:shop_app/providers/salesrep_customer_payment_aging_provider.dart';
import 'package:shop_app/providers/salesrep_profile_provider.dart';
import 'package:shop_app/providers/timelines_provider.dart';
import 'package:shop_app/providers/top_category_provider.dart';
import 'package:shop_app/providers/top_five_customers_provider.dart';
import 'package:shop_app/providers/top_five_products_provider.dart';
import 'package:shop_app/providers/user_data_provider.dart';
import 'package:shop_app/sales%20rep/rep_panel/salesrep_panel_page.dart';
import 'package:shop_app/storages/login_storage.dart';
import 'package:shop_app/theme.dart';
import 'customer/provider/categories_provider.dart';
import 'customer/screens/splash/password_screen.dart';
import 'providers/cost_of_good_sale_provider.dart';
import 'providers/customer_profile_provider.dart';
import 'providers/salesrep_discount_provider.dart';
import 'services/get_payment_service.dart';

String? myPublishKey;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('login_hive');
  await Hive.openBox('customer_cart_box');
  await Hive.openBox('salesrep_cart_box');

  runApp(Builder(builder: (BuildContext context) {
    return MultiProvider(
      // Wrap your app with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => PaymentGetProvider()),
      ],
      child: const MyApp(),
    );
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeStripe();
    saleRepGetPaymentKeyHandler();
  }

  saleRepGetPaymentKeyHandler() async {
    await GetPaymentKeyService().getPaymentKeyService(
        context: context, salRepId: loginStorage.getUserId());
  }

  LoginStorage loginStorage = LoginStorage();

  Future<void> initializeStripe() async {
    // var paymentProvider =
    //     Provider.of<PaymentGetProvider?>(context, listen: false);
    //
    // if (paymentProvider != null && paymentProvider.paymentKeyGetModel != null) {
    //   var stripeApiKey =
    //       paymentProvider.paymentKeyGetModel!.data!.publishableTestKey;
    //
    //   if (stripeApiKey == null || stripeApiKey.isEmpty) {
    //     print('Stripe publishable key is null or empty');
    //     return; // Exit the function if the key is not available
    //   }

    try {
      Stripe.publishableKey =
          'pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd';
      await Stripe.instance.applySettings();
    } catch (e) {
      print(e);
      // Handle the exception
    }
    // } else {
    //   print('PaymentGetProvider or paymentKeyGetModel is null');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => ResellerCustomerProvider()),
        ChangeNotifierProvider(create: (context) => ProductSearchProvider()),
        ChangeNotifierProvider(create: (context) => CustomersSearchProvider()),
        ChangeNotifierProvider(create: (context) => TimeLinesProvider()),
        ChangeNotifierProvider(create: (context) => SaleRepOrdersProvider()),
        ChangeNotifierProvider(create: (context) => AccountBalanceProvider()),
        // ChangeNotifierProvider(create: (context) => CustomerOrderProvider()),
        ChangeNotifierProvider(
            create: (context) => CustFavouritesProductsProvider()),
        ChangeNotifierProvider(create: (context) => ReviewsProvider()),
        ChangeNotifierProvider(create: (context) => AllOrdersProvider()),
        ChangeNotifierProvider(create: (context) => CartCounterProvider()),
        ChangeNotifierProvider(
            create: (context) => SaleRepPaymentsReportsProvider()),
        ChangeNotifierProvider(
            create: (context) => SalesrepAllCustomersPaymentsProvider()),
        ChangeNotifierProvider(
            create: (context) => SaleRepCustomOrderAgingProvider()),
        ChangeNotifierProvider(
            create: (context) => SalesRepCustomerPaymentAgingProvider()),
        ChangeNotifierProvider(
            create: (context) => OrderReportDetailsProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProfileProvider()),
        ChangeNotifierProvider(create: (context) => SalesrepProfileProvider()),
        ChangeNotifierProvider(create: (context) => TopCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CostOfGooddSaleProvider()),
        ChangeNotifierProvider(create: (context) => TopFiveProductProvider()),
        ChangeNotifierProvider(create: (context) => TopFiveCustomerProvider()),
        ChangeNotifierProvider(create: (context) => SalesrepDiscountProvider()),
        ChangeNotifierProvider(create: (context) => PaymentGetProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        // home: Platform.isIOS ? PasswordScreen() : SplashScreen(),
        home: SplashScreen(),
      ),
    );
  }

// Future<void> initializeAppData(BuildContext context) async {
//   try {
//     LoginStorage loginStorage = LoginStorage();
//     await GetPaymentKeyService().getPaymentKeyService(
//         salRepId: loginStorage.getUserId(), context: context);
//     var data =
//         Provider.of<GetPaymentKeyService>(context, listen: false).model;
//
//     String? mydata;
//     data.forEach((element) {
//       mydata = element.data!.publishableTestKey;
//       print('mydata---->${mydata}');
//     });
//     Stripe.publishableKey = mydata ??
//         'pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd';
//     await Stripe.instance.applySettings();
//   } catch (err) {
//     log('exception--->$err');
//   }
// }
}
