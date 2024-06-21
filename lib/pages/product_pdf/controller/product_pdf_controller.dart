import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_storage.dart';
import '../../../utils/date_utils.dart';
import '../../products/product_list/models/product_info.dart';
import '../../products/product_list/models/product_list_response.dart';

class ProductPdfController extends GetxController {
  List<String> widgetList = ['A', 'B', 'C'];
  double itemWidth = 0, itemHeight = 0;
  Uint8List? imageData;
  ImageProvider? imageUrl;
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;
  List<Uint8List?> attachments = [];
  int imageIndex = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    itemWidth = Get.width;
    itemHeight = Get.height;
    print("Width:" + Get.width.toString());
    print("Height:" + Get.height.toString());
    // final ByteData image = await rootBundle.load(Drawable.splashScreenLogo);
    // imageData = (image).buffer.asUint8List();

    // imageUrl = await networkImage(
    //     'https://www.onlygfx.com/wp-content/uploads/2022/02/vintage-hammer-clipart-cover.jpg');
    // if (imageUrl != null) {
    //   print("image not null");
    // } else {
    //   print("image null");
    // }

    // DefaultCacheManager()
    //     .downloadFile(
    //         "https://www.onlygfx.com/wp-content/uplds/2021/12/acorn-clipart-cover.jpg")
    //     .then((FileInfo info) {
    //   // imageUrl = info.file as ImageProvider?;
    //   print("File Path:" + info.file.path);
    //   Uint8List bytes = info.file.readAsBytesSync() as Uint8List;
    //   imageData = (bytes).buffer.asUint8List();
    // }).catchError(() {
    //   print("DefaultCacheManager catchError");
    // }).onError((error, stackTrace) {
    //   print("DefaultCacheManager onError");
    // });

    // DefaultCacheManager()
    //     .getFileFromCache(
    //         "https://www.onlygfx.com/wp-content/uploads/2022/02/vintage-hammer-clipart-cover.jpg")
    //     .then((value) => {
    //           if (value != null)
    //             {print("Saved Image:" + value!.file.path)}
    //           else
    //             {print("Not found file")}
    //         });

    // CachedNetworkImage(
    //   imageUrl: "http://via.placeholder.com/350x150",
    // );

    // new Future.delayed(Duration.zero,() {
    //   var size = MediaQuery.of(context).size;
    // });

    // getProductsData();
  }

  // void getProductsData() {
  //   if (AppStorage().getStockData() != null) {
  //     ProductListResponse response = AppStorage().getStockData()!;
  //     tempList.clear();
  //     tempList.addAll(response.info!);
  //     productList.value = tempList;
  //     print("Products Size:${productList.length}");
  //     loadAttachments();
  //   }
  // }

  void setProductsList(List<ProductInfo> listProducts) {
    tempList.clear();
    tempList.addAll(listProducts);
    productList.value = tempList;
    loadAttachments();
    // if (AppStorage().getStockData() != null) {
    //   ProductListResponse response = AppStorage().getStockData()!;
    //   tempList.clear();
    //   tempList.addAll(response.info!);
    //   productList.value = tempList;
    //   print("Products Size:${productList.length}");
    //   loadAttachments();
    // }
  }

  void loadAttachments() {
    attachments.clear;
    if (productList.isNotEmpty) {
      for (int i = 0; i < productList.length; i++) {
        attachments.add(null);
      }
      loadImage(productList[imageIndex].imageThumbUrl ?? "");
    }
  }

  void nextImageLoad() {
    if (imageIndex < productList.length - 1) {
      imageIndex = imageIndex + 1;
      loadImage(productList[imageIndex].imageThumbUrl ?? "");
    }
  }

  void loadImage(String imagePath) {
    if (!StringHelper.isEmptyString(imagePath)) {
      DefaultCacheManager().getFileFromCache(imagePath).then((value) {
        if (value != null) {
          attachments[imageIndex] = getUint8ListFromFile(value.file);
          nextImageLoad();
        } else {
          DefaultCacheManager()
              .downloadFile(imagePath)
              .then((FileInfo info) {
                attachments[imageIndex] = getUint8ListFromFile(info.file);
                nextImageLoad();
              })
              .catchError(() => nextImageLoad())
              .onError((error, stackTrace) {
                nextImageLoad();
              });
        }
      });
    } else {
      nextImageLoad();
    }
  }

  Uint8List? getUint8ListFromFile(File? file) {
    Uint8List? image;
    if (file != null) {
      Uint8List bytes = file!.readAsBytesSync() as Uint8List;
      image = (bytes).buffer.asUint8List();
    }
    return image;
  }

  Future<File> generateA4SizeMobilePdf(String name) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      build: (context) => [
        GridView(
            crossAxisCount: 1,
            childAspectRatio: 0.28,
            children: List.generate(
              productList.length,
              (position) {
                return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const PdfColor.fromInt(0xffc6c6c6)),
                        borderRadius: BorderRadius.circular(0)),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: productList[position].id != null
                                  ? productList[position].id!.toString()
                                  : productList[position].local_id!.toString(),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(productList[position].shortName ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: PdfColors.black, fontSize: 9)),
                          // SizedBox(height: 0.8 * PdfPageFormat.cm),
                        ])));
              },
            )),
      ],
      footer: (context) => Center(
          child: Text('Page ${context.pageNumber}/${context.pagesCount}')),
    ));

    return saveDocument(name: '$name.pdf', pdf: pdf);
  }

  Future<File> generateA4SizePdf(String name) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      build: (context) => [
        GridView(
            crossAxisCount: 4,
            childAspectRatio: 1.25,
            children: List.generate(
              productList.length,
              (position) {
                return Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const PdfColor.fromInt(0xffc6c6c6)),
                        borderRadius: BorderRadius.circular(0)),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: productList[position].id != null
                                  ? productList[position].id!.toString()
                                  : productList[position].local_id!.toString(),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(productList[position].shortName ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: PdfColors.black, fontSize: 9)),
                          // SizedBox(height: 0.8 * PdfPageFormat.cm),
                        ])));
              },
            )),
      ],
      footer: (context) => Center(
          child: Text('Page ${context.pageNumber}/${context.pagesCount}')),
    ));

    return saveDocument(name: '$name.pdf', pdf: pdf);
  }

  Future<File> generateA4SizeWithPicturePdf(String name) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      build: (context) => [
        GridView(
            crossAxisCount: 2,
            childAspectRatio: 0.45,
            children: List.generate(
              productList.length,
              (position) {
                return Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const PdfColor.fromInt(0xffc6c6c6)),
                        borderRadius: BorderRadius.circular(0)),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Stack(children: [
                            Container(width: 70, height: 70),
                            attachments[position] != null
                                ? Container(
                                    width: 70,
                                    height: 70,
                                    child: Center(
                                        child: Image(
                                            MemoryImage(
                                              attachments[position]!,
                                            ),
                                            width: 60,
                                            height: 60)))
                                : Container(width: 70, height: 70)
                          ]),
                          // Image(MemoryImage(imageData!), height: 100, width: 100),
                          // Text(
                          //   'Fist PDF',
                          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text(productList[position].shortName ?? "",
                                    maxLines: 4,
                                    style: TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                    height: !StringHelper.isEmptyString(
                                            productList[position].supplier_code)
                                        ? 5
                                        : 0),
                                !StringHelper.isEmptyString(
                                        productList[position].supplier_code)
                                    ? Text(
                                        "CODE: ${productList[position].supplier_code!}",
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: PdfColors.black,
                                            fontSize: 8))
                                    : Container()
                              ])),
                          SizedBox(width: 8),
                          Container(
                            height: 70,
                            width: 70,
                            child: BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: productList[position].id != null
                                  ? productList[position].id!.toString()
                                  : productList[position].local_id!.toString(),
                            ),
                          )
                          // SizedBox(height: 0.8 * PdfPageFormat.cm),
                        ])));
              },
            )),
      ],
      footer: (context) => Center(
          child: Text('Page ${context.pageNumber}/${context.pagesCount}')),
    ));

    return saveDocument(name: '$name.pdf', pdf: pdf);
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<void> writeFileToDownloadFolder(File file, String name) async {
    Uint8List data = getUint8ListFromFile(file)!;
    String tempDir = await _localPath;

    var now = DateTime.now();
    String randomString = DateUtil.dateToString(now, DateUtil.YYYY_MM_DD_TIME_24_WITHOUT_QUOTE);
    print(randomString);
    var filePath = '$tempDir/$name $randomString.pdf';
    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    // return File(filePath).writeAsBytes(
    //     buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    AppUtils.showSnackBarMessage('msg_file_downloaded'.tr);
  }

  static Future<File> writeFile(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name.pdf');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }

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
}
