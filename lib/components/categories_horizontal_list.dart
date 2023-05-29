import 'package:flutter/material.dart';

class CategoriesHorizontalList extends StatefulWidget {
  const CategoriesHorizontalList({Key? key}) : super(key: key);

  @override
  State<CategoriesHorizontalList> createState() =>
      _CategoriesHorizontalListState();
}

class _CategoriesHorizontalListState extends State<CategoriesHorizontalList> {
  /// images for categories
  List<String> images = [
    'https://images.pexels.com/photos/2533266/pexels-photo-2533266.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://media.istockphoto.com/id/1309367898/photo/curling-blonde-hair-on-a-large-diameter-curling-iron-on-a-pink-background-hair-health-concept.jpg?b=1&s=170667a&w=0&k=20&c=hvzP7WlfyKGnmZA6F_wCbsLwGCldREq12mhvCLhnTng=',
    'https://images.unsplash.com/photo-1630082900894-edbd503588f7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aGFpciUyMHByb2R1Y3R8ZW58MHx8MHx8&w=1000&q=80',
    'https://www.pngitem.com/pimgs/m/476-4766438_hair-styling-products-cosmetics-hd-png-download.png',
    'https://www.24newshd.tv/digital_images/large/2022-10-22/representational-image-1666415734-9788.jpg',
    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gh-012021-best-hair-products-1642523366.png?crop=0.502xw:1.00xh;0.250xw,0&resize=640:*',
    'https://cdn.accentuate.io/404431929565/1651229470124/biolage.jpg?v=0',
    'https://www.yormarket.com/wp-content/uploads/2021/08/Sulfate-Free-POSA-Hair-Care-Range-on-Yormarket-an-online-shopping-marketplace-1.jpeg',
    'https://www.sheknows.com/wp-content/uploads/2018/08/blow_dryer_cpzxua.png?w=1920',
    'https://pyxis.nymag.com/v1/imgs/e24/da3/0cad7679302026797a3521668ce66a5838-03-hair-dryers.2x.rsquare.w536.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
          itemCount: images.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black38, Colors.white30])),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Fashion',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Text(
                            '18 Brands',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
