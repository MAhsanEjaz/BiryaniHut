import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/customer/login/login_page.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/providers/sale_rep_orders_provider.dart';
import '../constants.dart';
import '../sales rep/salesrep_profile_screen.dart';

class CustomResellerBottomNavBar extends StatelessWidget {
  const CustomResellerBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final ResellerMenuState selectedMenu;
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
                    color: ResellerMenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context){
                    //   return ResellerHomePage();
                    // }));
                  }),
              IconButton(
                icon: const Icon(CupertinoIcons.profile_circled),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SalesrepProfileScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Provider.of<SaleRepOrdersProvider>(context, listen: false)
                      .repOrder!
                      .clear();
                  Hive.box("login_hive").clear();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
              ),
            ],
          )),
    );
  }
}
