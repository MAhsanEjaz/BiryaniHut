import 'package:flutter/material.dart';
import 'package:shop_app/customer/screens/cart/customer_cart_page.dart';
import 'package:shop_app/customer/screens/home/components/product_search_screen.dart';
import '../../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({Key? key, required this.cartCount}) : super(key: key);

  int cartCount;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: SearchField(
              controller: searchCont,
              onSubmit: (value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductSearchScreen(
                              prodName: searchCont.text,
                              isReseller: false,
                            )));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Expanded(
              child: IconBtnWithCounter(
                  numOfitem: widget.cartCount,
                  svgSrc: "assets/icons/Cart Icon.svg",
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerCartPage(),
                      ))),
            ),
          ),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfitem: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
