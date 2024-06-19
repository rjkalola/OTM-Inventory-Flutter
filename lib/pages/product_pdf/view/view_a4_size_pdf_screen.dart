import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../res/colors.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../controller/product_pdf_controller.dart';

class ViewA4SizePdfScreen extends StatefulWidget {
  const ViewA4SizePdfScreen({
    super.key,
  });

  @override
  State<ViewA4SizePdfScreen> createState() => _ViewA4SizePdfScreenState();
}

class _ViewA4SizePdfScreenState extends State<ViewA4SizePdfScreen> {
  final productPdfController = Get.put(ProductPdfController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'A4 Size Pdf',
          isCenterTitle: false,
          isBack: true,
          widgets: actionButtons(),
        ),
        body: Center(
          child: InkWell(
              onTap: () async {
                final pdfFile = await productPdfController.generateA4SizePdf();
                // final pdfFile = await PdfInvoicePdfHelper.generate(invoice);

                productPdfController.openFile(pdfFile);
              },
              child: Text("Generate Pdf")),
        ),
      ),
    );
  }

  Widget customTextView(String? text, double fontSize, FontWeight? fontWeight,
          Color color, EdgeInsetsGeometry padding) =>
      Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Flexible(
          child: Padding(
            padding: padding,
            child: Text(text ?? "",
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: color,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                )),
          ),
        ),
      );

  Widget dividerItem() => const Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor,
      );

  List<Widget>? actionButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Text(
          "",
          style: const TextStyle(
              fontSize: 18,
              color: defaultAccentColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    ];
  }
}
