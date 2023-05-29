// import 'package:flutter/material.dart';
// import 'package:shop_app/sales%20rep/timelines/models/user_model.dart';
// import 'package:shop_app/sales%20rep/timelines/widgets/profile_avatar.dart';
// import 'package:shop_app/widgets/custom_textfield.dart';

// class CreatePostContainer extends StatelessWidget {
//   final User currentUser;
//   final TextEditingController controller;

//   const CreatePostContainer({
//     required this.currentUser,
//     required this.controller,
//   }) : super();

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // margin: EdgeInsets.symmetric(horizontal:  0.0),
//       // elevation:  0.0,
//       // shape: isDesktop
//       //     ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
//       //     : null,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
//         color: Colors.white,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ProfileAvatar(imageUrl: currentUser.imageUrl),
//                 const SizedBox(width: 8.0),
//                 Expanded(
//                     child: CustomTextField(
//                   controller: controller,
//                   hint: "What's on your mind",
//                   inputType: TextInputType.text,
//                   prefixWidget: SizedBox(),
//                   isEnabled: true,
//                   isObscure: false,
//                   maxlines: 3,
//                   isshowPasswordControls: false,
//                 ))
//               ],
//             ),
//             const Divider(height: 10.0, thickness: 0.5),
//             Container(
//               height: 40.0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     onPressed: () => print('Live'),
//                     icon: const Icon(
//                       Icons.videocam,
//                       color: Colors.red,
//                     ),
//                     //  Text('Live')
//                   ),
//                   const VerticalDivider(width: 8.0),
//                   IconButton(
//                     onPressed: () => print('Photo'),
//                     icon: const Icon(
//                       Icons.photo_library,
//                       color: Colors.green,
//                     ),
//                     // label: Text('Photo'),
//                   ),
//                   const VerticalDivider(width: 8.0),
//                   IconButton(
//                     onPressed: () => print('Room'),
//                     icon: const Icon(
//                       Icons.video_call,
//                       color: Colors.purpleAccent,
//                     ),
//                     // label: Text('Room'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
