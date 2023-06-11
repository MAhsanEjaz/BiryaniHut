import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Email Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfEmailPage(),
    );
  }
}

class PdfEmailPage extends StatelessWidget {
  Future<String> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello, PDF!'),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/example.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  void sendEmail(String filePath) async {
    const recipient = 'example@gmail.com'; // Replace with the recipient's email
    const subject = 'Example PDF';
    final emailUrl =
        'mailto:$recipient?subject=${Uri.encodeFull(subject)}&body=Please find the attached PDF file.&attachment=$filePath';

    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Email Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final filePath = await generatePdf();
                sendEmail(filePath);
              },
              child: Text('Generate PDF and Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
