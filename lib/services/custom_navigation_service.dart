import 'package:flutter/cupertino.dart';

class CustomNavigationService {
  void customNavigationService(
      {required BuildContext context, required Widget child}) {
    Route route = PageRouteBuilder(maintainState: true,
        // fullscreenDialog: true,
        opaque: false,
        pageBuilder: (_, __, ___) {
          return child;
        });

    Navigator.of(context).push(route);
  }
}
