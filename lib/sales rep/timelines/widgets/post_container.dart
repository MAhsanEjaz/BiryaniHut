import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/timelines_model.dart';
import 'package:shop_app/sales%20rep/timelines/config/palette.dart';
import 'package:shop_app/sales%20rep/timelines/widgets/profile_avatar.dart';

class PostContainer extends StatefulWidget {
  final TimeLines post;

  const PostContainer({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  void initState() {
    super.initState();

    log("widget.post.imagePath = ${widget.post.imagePath}");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        // horizontal: isDesktop ? 5.0 : 0.0,
      ),
      // elevation: isDesktop ? 1.0 : 0.0,
      // shape: isDesktop
      //     ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
      //     : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // _PostHeader(post: widget.post),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.post.title.toString(),
                    style: nameStyle,
                  ),
                  Text(widget.post.description.toString()),
                  // widget.post.imagePath != null
                  //     ? const SizedBox.shrink()
                  //     : const SizedBox(height: 6.0),
                ],
              ),
            ),
            if (widget.post.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CachedNetworkImage(
                  // imageUrl: dummyImageUrl,
                  //widget.post.imagePath!
                  imageUrl: widget.post.imagePath!,
                  errorWidget: (context, url, error) {
                    return const SizedBox();
                  },
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _PostStats(),
            // ),
          ],
        ),
      ),
    );
  }

  // String getBroascastImageUrl(String url) {
  //   List<String> list = url.split("\\");
  //   log("My List ${list[6]}");

  //   url = imageBaseUrl + list.last;

  //   log("post new url = $url");
  //   // http://192.168.18.37:5955/influanceweb/productImages

  //   return url;
  // }
}

class _PostHeader extends StatelessWidget {
  // final Post post;
  //
  // const _PostHeader({
  //   required this.post,
  // }) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProfileAvatar(imageUrl: ''),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asad',
                style: TextStyle(fontWeight: FontWeight.w600, color: appColor),
              ),
              Row(
                children: [
                  Text(
                    '11hr • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  // Icon(
                  //   Icons.public,
                  //   color: Colors.grey[600],
                  //   size: 12.0,
                  // )
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () => print('More'),
        ),
      ],
    );
  }
}

class _PostStats extends StatelessWidget {
  // final Post post;
  //
  // const _PostStats({
  //   required this.post,
  // }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Palette.facebookBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thumb_up,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                '11',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '${'11'} Comments',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            // const SizedBox(width: 8.0),
            // Text(
            //   '${post.shares} Shares',
            //   style: TextStyle(
            //     color: Colors.grey[600],
            //   ),
            // )
          ],
        ),
        const Divider(),
        Row(
          children: [
            _PostButton(
              icon: Icon(
                MdiIcons.thumbUpOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Like',
              onTap: () => print('Like'),
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.commentOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Comment',
              onTap: () => print('Comment'),
            ),
            // _PostButton(
            //   icon: Icon(
            //     MdiIcons.shareOutline,
            //     color: Colors.grey[600],
            //     size: 25.0,
            //   ),
            //   label: 'Share',
            //   onTap: () => print('Share'),
            // )
          ],
        ),
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function onTap;

  const _PostButton({
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
