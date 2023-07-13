import 'package:flutter/cupertino.dart';

// class CustomNavigationService {
//   void customNavigationService(
//       {required BuildContext context, required Widget child}) {
//     Route route = PageRouteBuilder(maintainState: true,
//         // fullscreenDialog: true,
//         opaque: false,
//         pageBuilder: (_, __, ___) {
//           return child;
//         });
//
//     Navigator.of(context).push(route);
//   }
// }

class CustomNavigationService {
  void customNavigationService(
      {required BuildContext context, required Widget child}) {
    Route route = PageRouteBuilder(
      maintainState: true,
      opaque: false,
      pageBuilder: (_, __, ___) {
        return child;
      },
      transitionsBuilder: (_, animation, __, child) {
        // Apply a fade transition
        return FadeTransition(
          alwaysIncludeSemantics: true,
          opacity: animation,
          child: child,
        );
      },
    );

    Navigator.of(context).push(route);
  }
}
