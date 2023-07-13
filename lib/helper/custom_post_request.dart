import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomPostRequestService {
  Future httpPostRequest(
      {required BuildContext context,
      required String url,
      required Map body}) async {
    try {
      log("Post Request Url $url");
      var headers = {
        "Content-Type": "application/json",
        // "accept": "application/json",
      };
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      log("Post Request status code ${response.statusCode}");
      log("Post Request Body ${response.body}");

      var jsonDecoded = json.decode(response.body);
      return jsonDecoded;

      // if (jsonDecoded['message'] == 'Failed') {
      //   log("Invalid");
      //   return null;
      // } else {
      //   return jsonDecoded;
      // }
    } catch (err) {
      log(err.toString());

      return null;
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('')),
                  gradient: LinearGradient(
                      colors: [Colors.black12, Colors.orange.shade100])),
            )
          ],
        ),
      ),
    );
  }
}
