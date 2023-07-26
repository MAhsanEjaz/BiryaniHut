import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, String>> foodData = [
    {
      'name': 'Karahi',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNll9h6OsTK4PIS0ZO-AFflO4MvVBV__WpsA&usqp=CAU',
    },
    {
      'name': 'Biryani',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEdCm2JY_-fGgH0O05gXCJCCE2ic9eES7ddg&usqp=CAU',
    },
    {
      'name': 'Kebab',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsev3FENuuc81hfTI0hBDADv3brIpU6I2PxA&usqp=CAU',
    },
    {
      'name': 'Drinks',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4SiQHZZvDs17cb_NMexgS5yHImSEuOM0dLw&usqp=CAU',
    },
  ];

  int? selectIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < foodData.length; i++)
            CategoriesCard(
              title: foodData[i]['name'],
              image: foodData[i]['image'],
              cardColor: selectIndex == i ? true : false,
              onTap: () {
                selectIndex = i;
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}

class CategoriesCard extends StatefulWidget {
  bool cardColor;
  String? image;
  String? title;

  Function()? onTap;

  CategoriesCard({required this.cardColor, this.onTap, this.title, this.image});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: InkWell(
          onTap: (widget.onTap),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                              image: NetworkImage(widget.image!),
                              fit: BoxFit.cover),
                          border: Border.all(
                              color: widget.cardColor
                                  ? Colors.pink
                                  : Colors.white))),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                        color: widget.cardColor ? Colors.white : Colors.black,
                        fontWeight: widget.cardColor ? FontWeight.bold : null),
                  ),
                )
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: widget.cardColor ? appColor : Colors.black12,
            borderRadius: BorderRadius.circular(60),
            border: Border.all(
                color: widget.cardColor ? Colors.pink : Colors.white)),
      ),
    );
  }
}
