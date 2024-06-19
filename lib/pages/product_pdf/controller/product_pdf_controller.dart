import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class ProductPdfController extends GetxController {
  Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  Future<File> generateA4SizePdf() {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        Text("this is just test pdf"),
        Divider(),
        Text(
            "We analyzed this package 4 days ago, and awarded it 130 pub points (of a possible 160): We analyzed this package 4 days ago, and awarded it 130 pub points (of a possible 160):"),
      ],
      footer: (context) => Center(child: Text("www.stypix.in")),
    ));

    return saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
