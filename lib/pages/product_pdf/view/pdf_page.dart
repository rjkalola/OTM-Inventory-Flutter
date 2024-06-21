import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

import '../controller/product_pdf_controller.dart';

class PdfPage extends StatefulWidget {
  PdfPage({super.key});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final productPdfController = Get.put(ProductPdfController());

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(66, 196, 194, 194),
        appBar: AppBar(
          title: const Text("pdf"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                PrimaryButton(
                    buttonText: "Generate Pdf",
                    onPressed: () async {
                      final date = DateTime.now();
                      final dueDate = date.add(
                        const Duration(days: 7),
                      );
                      final pdfFile = await productPdfController
                          .generateA4SizeMobilePdf("test pdf");
                      print("pdfFile:" + pdfFile.path);
                      productPdfController.openFile(pdfFile);
                    })
              ],
            ),
          ),
        ),
      );
}
