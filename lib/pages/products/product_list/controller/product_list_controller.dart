import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/product_list/controller/product_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/module_info.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../common/listener/select_item_listener.dart';
import '../../../common/select_Item_list_dialog.dart';
import '../../../product_pdf/controller/product_pdf_controller.dart';
import '../models/product_info.dart';
import '../models/product_list_response.dart';

class ProductListController extends GetxController
    implements SelectItemListener {
  final _api = ProductListRepository();
  final searchController = TextEditingController().obs;
  final productPdfController = Get.put(ProductPdfController());

  final productListResponse = ProductListResponse().obs;
  List<ProductInfo> tempList = [], selectedPrintProduct = [];
  final productList = <ProductInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLoadMore = false.obs,
      isPrintEnable = false.obs,
      isCheckAllPrint = false.obs,
      isClearVisible = false.obs;

  final filters = ''.obs, search = ''.obs;

  var offset = 0;
  var mIsLastPage = false;
  late ScrollController controller;
  File? mPrintFile;
  String mPrintFileName = "";

  @override
  void onInit() {
    super.onInit();
    controller = ScrollController();
    // controller.addListener(_scrollListener);
    // getProductListApi(true, "0", true);
    setOfflineData();
  }

  void setOfflineData() {
    isMainViewVisible.value = true;
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      tempList.clear();
      tempList.addAll(response.info!);
      productList.value = tempList;
      productList.refresh();
    }
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !mIsLastPage) {
      print("reach the bottom");
      getProductListApi(false, "0", false);
    }
    // if (controller.offset <= controller.position.minScrollExtent &&
    //     !controller.position.outOfRange) {
    //   print("reach the top");
    // }
  }

  Future<void> addProductClick(ProductInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.productInfo: info,
        AppConstants.intentKey.productId: info.id.toString()
      };
      // var arguments = {
      //   AppConstants.intentKey.productId: info.id.toString(),
      // };
      result = await Get.toNamed(AppRoutes.addStockProductScreen,
          arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addStockProductScreen);
    }

    if (result != null && result) {
      // getProductListApi(true, "0", true);
      setOfflineData();
    }
  }

  // Future<void> searchItem(String value) async {
  //   print(value);
  //   List<ProductInfo> results = [];
  //   if (value.isEmpty) {
  //     results = tempList;
  //   } else {
  //     results = tempList
  //         .where((element) =>
  //             element.name!.toLowerCase().contains(value.toLowerCase()))
  //         .toList();
  //   }
  //   productList.value = results;
  // }

  Future<void> searchItem(String value) async {
    print(value);
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.shortName) &&
                  element.shortName!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.name) &&
                  element.name!.toLowerCase().contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.description) &&
                  element.description!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.barcode_text) &&
                  element.barcode_text!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (listCategories(element.categories!)
                  .contains(value.toLowerCase())))
          .toList();
    }
    productList.value = results;
  }

  List<String> listCategories(List<ModuleInfo>? list) {
    List<String> categoryNames = [];
    if (!StringHelper.isEmptyList(list)) {
      for (var item in list!) {
        categoryNames.add(item.name!.toLowerCase());
      }
    }
    return categoryNames;
  }

  Future<void> openQrCodeScanner() async {
    var result = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (result != null && !StringHelper.isEmptyString(result)) {
      // getProductListApi(true, result, true);
      setOfflineData();
    }
  }

  Future<void> getProductListApi(
      bool isProgress, String productId, bool clearOffset) async {
    if (clearOffset) {
      offset = 0;
      mIsLastPage = false;
    }

    isLoadMore.value = offset > 0;

    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = productId;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getProductList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            isMainViewVisible.value = true;
            if (offset == 0) {
              tempList.clear();
              tempList.addAll(response.info!);
              productList.value = tempList;
              productList.refresh();
            } else if (response.info != null && response.info!.isNotEmpty) {
              tempList.addAll(response.info!);
              productList.value = tempList;
              productList.refresh();
            }

            offset = response.offset!;
            if (offset == 0) {
              mIsLastPage = true;
            } else {
              mIsLastPage = false;
            }

            print("tempList size:" + tempList.length.toString());
            print("productList size:" + productList.length.toString());
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  onClickPrintButton() {
    productPdfController.setProductsList(selectedPrintProduct);

    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'A4'.tr;
    info.action = AppConstants.action.a4Print;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'A4 with Pictures'.tr;
    info.action = AppConstants.action.a4WithPicturesPrint;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'Mobile Printer'.tr;
    info.action = AppConstants.action.mobilePrint;
    listOptions.add(info);

    // showAttachmentOptionsDialog(
    //     AppConstants.dialogIdentifier.attachmentOptionsList,
    //     'select_photo'.tr,
    //     listOptions,
    //     this);

    showPrintOptionsDialog(AppConstants.dialogIdentifier.attachmentOptionsList,
        'choose_type'.tr, listOptions, this);
  }

  dialogViewDownloadOptions() {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'view_pdf'.tr;
    info.action = AppConstants.action.viewPdf;
    listOptions.add(info);

    // info = ModuleInfo();
    // info.name = 'download_pdf'.tr;
    // info.action = AppConstants.action.downloadPdf;
    // listOptions.add(info);

    showPrintOptionsDialog(AppConstants.dialogIdentifier.attachmentOptionsList,
        'choose_type'.tr, listOptions, this);
  }

  void showPrintOptionsDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        SelectItemListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  @override
  Future<void> onSelectItem(
      int position, int id, String name, String action) async {
    if (action == AppConstants.action.a4Print) {
      mPrintFile = await productPdfController.generateA4SizePdf('A4'.tr);
      mPrintFileName = 'A4'.tr;
      if (mPrintFile != null) dialogViewDownloadOptions();
      // productPdfController.writeFileToDownloadFolder(pdfFile, "PDF Test");
      // productPdfController.openFile(pdfFile);
    } else if (action == AppConstants.action.a4WithPicturesPrint) {
      mPrintFile = await productPdfController
          .generateA4SizeWithPicturePdf('A4 with Pictures'.tr);
      mPrintFileName = 'A4 with Pictures'.tr;
      if (mPrintFile != null) dialogViewDownloadOptions();
      // viewPdf(pdfFile.path);
      // productPdfController.openFile(pdfFile);
    } else if (action == AppConstants.action.mobilePrint) {
      mPrintFile = await productPdfController
          .generateA4SizeMobilePdf('Mobile Printer'.tr);
      mPrintFileName = 'Mobile Printer'.tr;
      if (mPrintFile != null) dialogViewDownloadOptions();
      // viewPdf(pdfFile.path);
      // productPdfController.openFile(pdfFile);
    } else if (action == AppConstants.action.viewPdf) {
      viewPdf();
    } else if (action == AppConstants.action.downloadPdf) {
      if (mPrintFile != null)
        productPdfController.writeFileToDownloadFolder(
            mPrintFile!, mPrintFileName);
    }
  }

  void viewPdf() {
    if (mPrintFile != null) productPdfController.openFile(mPrintFile!);
    // var arguments = {
    //   AppConstants.intentKey.pdfUrl: url,
    // };
    // Get.toNamed(AppRoutes.viewPdfScreen, arguments: arguments);
  }

  void checkAllProducts() {
    for (var info in productList) {
      info.checkPrint = true;
    }
  }

  void unCheckAllProducts() {
    for (var info in productList) {
      info.checkPrint = false;
    }
  }
}
