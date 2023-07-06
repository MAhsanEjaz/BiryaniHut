import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';

class LoginStorage {
  final box = Hive.box('login_hive');

//! user auth token
  void setUserToken({required String token}) {
    log("user token in hive = $token");
    box.put("token", token);
  }

  String getUserToken() {
    return box.get("token");
  }

  void setIsLogin({required bool login}) {
    log("user login in hive = $login");
    box.put("login", login);
  }

  bool getIsLogin() {
    if (box.get('login') == null) {
      return false;
    }
    return box.get("login");
  }

  void setUserId({required int id}) {
    log("user id in hive = $id");
    box.put("id", id);
  }

  int getUserId() {
    return box.get("id");
  }

  void setUserEmail({required String email}) {
    log("user id in hive = $email");
    box.put("email", email);
  }

  String getUserEmail() {
    return box.get("email");
  }

  void setUserFirstName({required String fName}) {
    log("user fName in hive = $fName");
    box.put("fName", fName);
  }

  String getUserFirstName() {
    return box.get("fName");
  }

  void setAdress({required String adress}) {
    log("user adress in hive = $adress");
    box.put("adress", adress);
  }

  String getAdress() {
    return box.get("adress");
  }

  void setPhone({required String phone}) {
    log("user phone in hive = $phone");
    box.put("phone", phone);
  }

  String getPhone() {
    return box.get("phone");
  }

  void setUserLastName({required String lName}) {
    log("user lName in hive = $lName");
    box.put("lName", lName);
  }

  String getUserLastName() {
    return box.get("lName");
  }

//! push notificatons device id
  void setUserDeviceId({required String deviceId}) {
    log("user deviceId in hive = $deviceId");
    box.put("deviceId", deviceId);
  }

  String getUserDeviceId() {
    return box.get("deviceId");
  }

//! still not being used
  void setUserType({required String usertype}) {
    log("usertype in hive = $usertype");
    box.put("usertype", usertype);
  }

  String getUsertype() {
    if (box.get("usertype") == null) {
      return "";
    }
    return box.get("usertype");
  }

  void setUserAvatar({required String avatar}) {
    log("user avatar in hive = $avatar");
    box.put("avatar", avatar);
  }

  String getUserAvatar() {
    return box.get("avatar");
  }

  void setSalesRepId({required int repId}) {
    log("user avatar in hive = $repId");
    box.put("repid", repId);
  }

  int? getSalesRepId() {
    return box.get("repid");
  }

  void setSalesRepName({required String repName}) {
    log("user avatar in hive = $repName");
    box.put("repname", repName);
  }

  String getSalesRepName() {
    return box.get("repname");
  }

  void setSalesRepCompany({required String company}) {
    log("company in hive = $company");
    box.put("repCompany", company);
  }

  String getSalesRepCompany() {
    return box.get("repCompany");
  }

  void setStripeKey({required String stripeKey}) {
    log("setStripeKey stripeKey hive = $stripeKey");
    box.put("stripeKey", stripeKey);
  }

  String? getStripeKey() {
    return box.get("stripeKey");
  }
}
