import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_repository.dart';
import 'package:otm_inventory/pages/store_list/model/store_info.dart';
import 'package:otm_inventory/pages/store_list/model/store_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/base_response.dart';
import '../../../web_services/response/response_model.dart';
import '../../common/model/file_info.dart';
import '../../products/add_product/controller/add_product_repository.dart';
import '../../products/product_list/models/product_info.dart';
import '../../products/product_list/models/product_list_response.dart';
import '../../stock_edit_quantiry/model/store_stock_request.dart';
import '../../stock_list/stock_list_repository.dart';
import '../listener/barcode_save_listener.dart';
import '../view/edit_barcode_dialog.dart';

class BarcodeListController extends GetxController
    implements BarcodeSaveListener {
  var barcodeList = <String>[].obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  var mBarCode = "".obs;
  var selectedPosition = 0;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      mBarCode.value = arguments[AppConstants.intentKey.barCode] ?? "";
      if (!StringHelper.isEmptyString(mBarCode.value)) {
        barcodeList.value =
            StringHelper.getListFromCommaSeparateString(mBarCode.value);
      }
    }
    print("mBarCode:" + mBarCode.value);
  }

  void showEditBarcodeDialog(String mBarcode, bool isAdd, int position) {
    Get.bottomSheet(
        EditBarcodeDialog(
          barcode: mBarcode,
          isAdd: isAdd,
          position: position,
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  @override
  void onBarcodeSave(String barcode, bool add, int position) {
    if (add) {
      barcodeList.add(barcode);
    } else {
      barcodeList[position] = barcode;
    }
  }
}
