// pdf_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<File> generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Text('Hello, PDF!'),
        );
      },
    ));
    final bytes = await pdf.save();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
