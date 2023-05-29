import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/helper/custom_snackbar.dart';

class CustomGetRequestService {
  Future httpGetRequest(
      {required BuildContext context, required String url}) async {
    log("Get Request Url $url");

    // try {
    http.Response response = await http.get(Uri.parse(url));
    log("get request status code ${response.statusCode}");
    log("get request body${response.body}");
    var jsonDecoded = json.decode(response.body);
    if (response.statusCode != 200) {
      log("Invalid");
      log("status code in $url = ${response.statusCode}");
    } else {
      return jsonDecoded;
    }
    // } catch (err) {
    //   CustomSnackBar.showSnackBar(
    //     message: "Something Went Wrong",
    //     context: context,
    //   );
    //   log("Exception in Custom Get Requeset Service $err");
    //   // return null;
    // }
  }
}
