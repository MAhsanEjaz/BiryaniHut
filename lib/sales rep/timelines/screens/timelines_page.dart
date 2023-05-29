import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/custom_loader.dart';
import 'package:shop_app/models/timelines_model.dart';
import 'package:shop_app/providers/timelines_provider.dart';
import 'package:shop_app/sales%20rep/timelines/widgets/post_container.dart';
import 'package:shop_app/services/time_lines_services.dart';

class TimelinesPage extends StatefulWidget {
  const TimelinesPage({Key? key}) : super(key: key);

  @override
  _TimelinesPageState createState() => _TimelinesPageState();
}

class _TimelinesPageState extends State<TimelinesPage> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  timeLineHandler() async {
    CustomLoader.showLoader(context: context);
    await TimeLinesService().getTimeLines(context: context);
    CustomLoader.hideLoader(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timeLineHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<TimeLinesProvider>(builder: (context, data, _) {
        return Scaffold(
          // appBar: AppBar(title: Text("Timelines")),
          body: TimelineScreen(time: data.timeLines),
        );
      }),
    );
  }
}

class TimelineScreen extends StatefulWidget {
  List<TimeLines>? time = [];

  TimelineScreen({Key? key, this.time}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: appColor,
          iconTheme: iconTheme,
          title: Text('Timeline', style: appbarTextStye),
          centerTitle: false,
          floating: true,
          pinned: true,

          // actions: [
          //   CircleButton(
          //     icon: Icons.search,
          //     iconSize: 30.0,
          //     onPressed: () => print('Search'),
          //   ),
          // CircleButton(
          //   icon: MdiIcons.facebookMessenger,
          //   iconSize: 30.0,
          //   onPressed: () => print('Messenger'),
          // ),
          // ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        // SliverToBoxAdapter(
        //   child: CreatePostContainer(
        //     currentUser: currentUser,
        //     controller: searchCont,
        //   ),
        // ),
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
        //   sliver: SliverToBoxAdapter(
        //     child: Rooms(onlineUsers: onlineUsers),
        //   ),
        // ),
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        //   sliver: SliverToBoxAdapter(
        //     child: Stories(
        //       currentUser: currentUser,
        //       stories: stories,
        //     ),
        //   ),
        // ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return PostContainer(post: widget.time![index]);
            },
            childCount: widget.time!.length,
          ),
        ),

        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       final Post post = posts[index];
        //       return PostContainer(post: post);
        //     },
        //     childCount: posts.length,
        //   ),
        // ),
      ],
    );
  }
}
