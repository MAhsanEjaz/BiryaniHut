import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/customer/login/login_page.dart';
import 'package:shop_app/customer/screens/home/customer_home_page.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/storages/login_storage.dart';
import '../../../sales rep/salesrep_dashboard.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Influance Hair Care, Let’s shop!",
      "image": "assets/images/Updated Products Everyday.svg"
    },
    {
      "text": "Seamless and Secure Payment",
      "image": "assets/images/Easy Transaction And Payment.svg"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/Free-Shipping vouchers.svg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    //! You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        LoginStorage loginStorage = LoginStorage();

                        if (loginStorage.getIsLogin()) {
                          if (loginStorage.getUsertype() == "customer") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomerHomePage(),
                                  // builder: (context) => SalesrepDashboardPage(),
                                  // builder: (context) => LoginPage(),
                                ));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SalesRepDashboardPage(),
                                  // builder: (context) => LoginPage(),
                                ));
                          }
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        }
                        log("Continue presssssed");
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => CustomerHomePage(),
                        // builder: (context) => SalesrepDashboardPage(),
                        // builder: (context) => LoginPage(),
                        // ));
                        // Navigator.pushNamed(context, HomePage.routeName);
                      },
                    ),
                    const Text("Version 4.0.0"),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
