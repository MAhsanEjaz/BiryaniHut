import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/components/common_widgets.dart';
import 'package:shop_app/customer/favourites.dart/favourites_page.dart';
import '../constants.dart';
import '../customer/login/login_page.dart';
import '../customer/screens/order_history/customer_orders_page.dart';
import '../customer/screens/customer_profile/customer_profile_screen.dart';
import '../enums.dart';

class CustomCustomBottomNavBar extends StatelessWidget {
  const CustomCustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;
  final Color inActiveIconColor = const Color(0xFFB6B6B6);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
// Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CustomerHomePage(),
//                       ));
                  }),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  // showToast("under development");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavouritesPage(),
                      ));
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/order_history.svg",
                  height: 25,
                  width: 25,
                  color: Colors.grey.withOpacity(.9),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  // showToast("under development");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerOrderHistoryPage(),
                      ));
                },
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const CustomerProfileScreen()));
                  }),
              // Navigator.pushNamed(context, ProfileScreen.routeName),
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LoginPage(),
              //     ))),
            ],
          )),
    );
  }
}
