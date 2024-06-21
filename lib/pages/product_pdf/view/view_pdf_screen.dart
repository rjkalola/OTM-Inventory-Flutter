import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../res/colors.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../controller/product_pdf_controller.dart';

class ViewPdfScreen extends StatefulWidget {
  const ViewPdfScreen({
    super.key,
  });

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  final productPdfController = Get.put(ProductPdfController());
  String pdfUrl = "";
  late PDFViewController pdfViewController;

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    if (arguments != null) {
      pdfUrl = arguments[AppConstants.intentKey.pdfUrl];
      print("pdfUrl:" + pdfUrl);
    }
  }

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
        body: PDFView(
          filePath: pdfUrl,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          fitEachPage: true,
          fitPolicy: FitPolicy.BOTH,
          onError: (error) {
            print(error);
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController vc) {
            pdfViewController = vc;
          },
          onPageChanged: (int? page, int? total) {
            print('page change: $page/$total');
          },
        ),
      ),
    );
  }

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
