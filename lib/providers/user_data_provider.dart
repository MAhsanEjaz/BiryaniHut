import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? user;
  updateUser({UserModel? newUser}) {
    user = newUser;
    notifyListeners();
  }
}
