import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyNewPracticeScreen extends StatefulWidget {
  const MyNewPracticeScreen({Key? key}) : super(key: key);

  @override
  State<MyNewPracticeScreen> createState() => _MyNewPracticeScreenState();
}

class _MyNewPracticeScreenState extends State<MyNewPracticeScreen> {
  final imagePick = ImagePicker();

  List<XFile> file = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final myfile = await imagePick.pickMultiImage();
                    myfile.forEach((element) {
                      file.add(element);
                      setState(() {});
                    });
                  },
                  child: const Text("Select Camera")),
              ElevatedButton(
                  onPressed: () async {
                    final filePath =
                        await imagePick.pickImage(source: ImageSource.camera);

                    file.add(filePath!);
                    setState(() {});
                  },
                  child: const Text("Select Gallery")),
              Wrap(
                children: [
                  for (var l in file)
                    Container(
                        height: 100,
                        width: MediaQuery.sizeOf(context).width / 2.2,
                        decoration: BoxDecoration(
                          image:
                              DecorationImage(image: FileImage(File(l.path))),
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  File? image;
  String? imagePath;

  _convertIntoBase() async {
    if (image != null) {
      List<int> bytes = await image!.readAsBytesSync();
      String base64 = base64Encode(bytes);

      imagePath = base64;

      setState(() {});
    }
  }
}
