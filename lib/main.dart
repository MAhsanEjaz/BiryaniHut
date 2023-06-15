import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/screens/splash/splash_screen.dart';
import 'package:shop_app/providers/account_balance_provider.dart';
import 'package:shop_app/providers/all_orders_provider.dart';
import 'package:shop_app/providers/counter_provider.dart';
import 'package:shop_app/providers/cust_favourites_product_provider.dart';
import 'package:shop_app/providers/customers_search_provider.dart';
import 'package:shop_app/providers/order_report_details_provider.dart';
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
import 'package:shop_app/theme.dart';
import 'customer/provider/categories_provider.dart';
import 'customer/screens/splash/password_screen.dart';
import 'pdf_example_screen.dart';
import 'providers/cost_of_good_sale_provider.dart';
import 'providers/customer_profile_provider.dart';
import 'providers/salesrep_discount_provider.dart';

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

  await Hive.initFlutter();
  await Hive.openBox('login_hive');
  await Hive.openBox('customer_cart_box');
  await Hive.openBox('salesrep_cart_box');

//! use this as your package name for ios
//! as it is used in ios appstore app.
// com.app.influance_hair_care

  WidgetsFlutterBinding.ensureInitialized();
  // var data = await CustomDb().getKey();
  String? publishableKey = await CustomDb().getKey();
  // String? stripeKey = LoginStorage().getStripeKey();

  log("publishableKey at start = $publishableKey");
  Stripe.publishableKey = publishableKey ??
      'pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ChangeNotifierProvider(create: (context) => OrderReportDetailsProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProfileProvider()),
        ChangeNotifierProvider(create: (context) => SalesrepProfileProvider()),
        ChangeNotifierProvider(create: (context) => TopCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CostOfGooddSaleProvider()),
        ChangeNotifierProvider(create: (context) => TopFiveProductProvider()),
        ChangeNotifierProvider(create: (context) => TopFiveCustomerProvider()),
        ChangeNotifierProvider(create: (context) => SalesrepDiscountProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          // home: SplashScreen(),
          home: Platform.isIOS ? PasswordScreen() : SplashScreen(),
          // home: PdfEmailPage(),
          // home: MyNewPracticeScreen(),
          // home: ImagePickerPage(),
          // home: MyPracticeProductScreen(),
        ),
      ),
    );
  }
}

// flutter clean && flutter pub get && pod install &&
// pod repo update
