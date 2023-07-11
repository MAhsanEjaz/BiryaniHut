import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/all_cities_model.dart';
import 'package:shop_app/models/states_model.dart';
import 'package:shop_app/providers/all_cities_provider.dart';
import 'package:shop_app/providers/states_provider.dart';
import 'package:shop_app/services/get_all_cities_service.dart';
import 'package:shop_app/services/get_all_states_services.dart';

import '../../components/salesrep_customers_widget.dart';
import '../../helper/custom_loader.dart';
import '../../helper/custom_snackbar.dart';

class DropDownCityScreen extends StatefulWidget {
  String cityName;
  String statesName;

  DropDownCityScreen({required this.cityName, required this.statesName});

  @override
  State<DropDownCityScreen> createState() => _DropDownCityScreenState();
}

class _DropDownCityScreenState extends State<DropDownCityScreen>
    with TickerProviderStateMixin {
  // String? statesName;
  // String? cityName;

  List<AllStatesModel> statesModel = [];

  List<AllCitiesModel> cityModel = [];

  citiesHandler(String? cityName) async {
    CustomLoader.showLoader(context: context);

    await GetAllCitiesService()
        .getAllCitiesService(context: context, cityName: cityName!);
    CustomLoader.hideLoader(context);
    cityModel = Provider.of<AllCitiesProvider>(context, listen: false).cities!;

    print(cityModel);
    setState(() {});
  }

  getAllStatesHandler(String cityName) async {
    CustomLoader.showLoader(context: context);
    await GetAllStatesServices()
        .getAllStatesServices(context: context, cityName: cityName);

    statesModel =
        Provider.of<StatesProvider>(context, listen: false).statesData!;
    print('states---->$statesModel');
    setState(() {});

    CustomLoader.hideLoader(context);
  }

  TextEditingController controller = TextEditingController();

  AnimationController? _controller;
  Animation<double>? _animation;
  bool expand = false;
  bool showSearchData = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //     side: BorderSide(
                //         color: expand == true
                //             ? Colors.black26
                //             : Colors.transparent)),
                // elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    expand = !expand;
                    _controller = AnimationController(
                        duration: const Duration(seconds: 1), vsync: this);
                    // Define the animation curve
                    final curvedAnimation = CurvedAnimation(
                        parent: _controller!, curve: Curves.easeInExpo);

                    // Define the animation values (e.g., from 0.0 to 1.0)
                    _animation = Tween<double>(begin: 0.0, end: 1.0)
                        .animate(curvedAnimation);
                    _controller!.forward();
                    setState(() {});
                    (() {});
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/City Icon (1).svg",
                                height: 23,
                                width: 23,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                city == null ? widget.cityName : city!,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Icon(expand == true
                                  ? Icons.arrow_drop_up_outlined
                                  : Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                        expand == true
                            ? AnimatedBuilder(
                                animation: _animation!,
                                builder: (BuildContext context, Widget? child) {
                                  return Opacity(
                                    opacity: _animation!.value,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: CupertinoTextField(
                                                controller: controller,
                                                placeholder: 'Search Cities',
                                                onSubmitted: (v) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    controller.text.length < 3
                                                        ? CustomSnackBar
                                                            .failedSnackBar(
                                                                context:
                                                                    context,
                                                                message:
                                                                    'Text should be at least 3 characters long')
                                                        : citiesHandler(v);
                                                    showSearchData = true;

                                                    setState(() {});
                                                  });
                                                }),
                                          ),
                                          const SizedBox(height: 10),
                                          showSearchData == true
                                              ? cityModel.isEmpty
                                                  ? const Center(
                                                      child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                          ('City not found')),
                                                    ))
                                                  : Column(
                                                      children:
                                                          cityModel.map((e) {
                                                        return InkWell(
                                                          onTap: () {
                                                            city = e.cityName!;
                                                            // model = cities;
                                                            expand = !expand;
                                                            print(
                                                                'cityy===>${city}');

                                                            WidgetsBinding
                                                                .instance
                                                                .addPostFrameCallback(
                                                                    (timeStamp) {
                                                              getAllStatesHandler(
                                                                  city!);
                                                            });

                                                            setState(() {});
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              e.cityName!,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    )

                                              // ListView.builder(
                                              //             physics:
                                              //                 const NeverScrollableScrollPhysics(),
                                              //             shrinkWrap: true,
                                              //             itemCount:
                                              //                 cityModel.length,
                                              //             itemBuilder:
                                              //                 (context, index) {
                                              //               return InkWell(
                                              //                 onTap: () {
                                              //                   widget.selectedName =
                                              //                       cityModel[index]
                                              //                           .cityName!;
                                              //                   // model = cities;
                                              //                   expand = !expand;
                                              //
                                              //                   WidgetsBinding
                                              //                       .instance
                                              //                       .addPostFrameCallback(
                                              //                           (timeStamp) {
                                              //                     getAllStatesHandler(
                                              //                         widget
                                              //                             .selectedName);
                                              //                   });
                                              //
                                              //                   setState(() {});
                                              //                 },
                                              //                 child: Padding(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                               .symmetric(
                                              //                           horizontal:
                                              //                               20.0,
                                              //                           vertical:
                                              //                               10),
                                              //                   child: Text(
                                              //                     cityModel[index]
                                              //                         .cityName!,
                                              //                     style:
                                              //                         const TextStyle(
                                              //                             fontSize:
                                              //                                 16),
                                              //                   ),
                                              //                 ),
                                              //               );
                                              //             })
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              height: 45.0,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: DropdownButton(
                    hint: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/State Icon (1).svg",
                          width: 26,
                          height: 26,
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(width: 13),
                        Text(state == null ? widget.statesName : state!),
                      ],
                    ),
                    underline: const SizedBox(),
                    // padding:
                    //     const EdgeInsets
                    //         .all(0),
                    isExpanded: true,
                    items: statesModel.map((e) {
                      return DropdownMenuItem(
                          onTap: () {
                            state = e.stateName!;
                            setState(() {});
                          },
                          value: e,
                          child: Text(e.stateName!));
                    }).toList(),
                    onChanged: (_) {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
