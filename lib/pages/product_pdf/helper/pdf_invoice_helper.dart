import 'dart:io';


import 'package:otm_inventory/pages/product_pdf/helper/pdf_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoicePdfHelper {
  static Future<File> generate() async {
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

    return PdfHelper.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
