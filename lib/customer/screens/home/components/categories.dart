import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/size_config.dart';

import '../../../provider/categories_provider.dart';
import '../../../services/categories_service.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedIndex = 0;
  final List<String> imagesList = [
    "assets/icons/Flash Icon.svg",
    "assets/icons/Bill Icon.svg",
    "assets/icons/Game Icon.svg",
    "assets/icons/Gift Icon.svg",
    "assets/icons/Discover.svg",
  ];

  catHandler() async {
    CustomLoader.showLoader(context: context);
    await CategoriesService().getCat(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      catHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10.0)),
        child: Consumer<CategoriesProvider>(
          builder: (context, cat, _) {
            return cat.catList!.isNotEmpty
                ? SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: cat.catList!.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext, index) {
                          return CategoryTabWidget(
                            text: cat.catList![index].categoryName ?? "",
                            selectedColor:
                                selectedIndex == index ? true : false,
                            imageUrl: imagesList[index],
                            onTap: () {
                              selectedIndex = index;
                              setState(() {});
                            },
                          );
                        }),
                  )
                : SizedBox();
          },
        ));
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    this.bgColor,
  }) : super(key: key);

  final String? icon, text;
  Color? bgColor;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: bgColor ?? kSecondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!),
            ),
            SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class CategoryHeading extends StatelessWidget {
  final String title, desc;

  const CategoryHeading({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: kPrimaryColor,
                    // fontWeight: FontWeight.bold,
                    fontSize: 25)),
            Text(desc,
                style: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5))),
          ],
        ),
      ),
    );
  }
}

class CategoryTabWidget extends StatelessWidget {
  final String text;
  final bool selectedColor;
  final Function()? onTap;
  final String imageUrl;

  const CategoryTabWidget({
    Key? key,
    required this.text,
    this.selectedColor = false,
    this.onTap,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            height: 40,
            width: 50,
            decoration: BoxDecoration(
                color: selectedColor ? appColor : appColor.withOpacity(.4),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: SvgPicture.asset(
                "$imageUrl",
                color: whiteColor,
              ),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontFamily: 'Raleway', height: 1.3
              // color: textColor
              ),
        )
      ],
    );
  }
}
