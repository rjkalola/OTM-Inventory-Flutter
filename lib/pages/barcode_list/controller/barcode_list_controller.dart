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
import '../../../utils/AlertDialogHelper.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/base_response.dart';
import '../../../web_services/response/response_model.dart';
import '../../common/listener/DialogButtonClickListener.dart';
import '../../common/model/file_info.dart';
import '../../products/add_product/controller/add_product_repository.dart';
import '../../products/product_list/models/product_info.dart';
import '../../products/product_list/models/product_list_response.dart';
import '../../stock_edit_quantiry/model/store_stock_request.dart';
import '../../stock_list/stock_list_repository.dart';
import '../listener/barcode_save_listener.dart';
import '../view/edit_barcode_dialog.dart';

class BarcodeListController extends GetxController
    implements BarcodeSaveListener, DialogButtonClickListener {
  var barcodeList = <String>[].obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  var mBarCode = "".obs;
  var selectedPosition = 0, productId = 0, localProductId = 0;
  EditBarcodeDialog? editBarcodeDialog;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      mBarCode.value = arguments[AppConstants.intentKey.barCode] ?? "";
      productId = arguments[AppConstants.intentKey.productId] ?? 0;
      localProductId = arguments[AppConstants.intentKey.localProductId] ?? 0;
      print("productId:" + productId.toString());
      print("localProductId:" + localProductId.toString());

      if (!StringHelper.isEmptyString(mBarCode.value)) {
        barcodeList.value =
            StringHelper.getListFromCommaSeparateString(mBarCode.value);
      }
    }
    print("mBarCode:" + mBarCode.value);
  }

  void showEditBarcodeDialog(String mBarcode, bool isAdd, int position) {
    editBarcodeDialog = EditBarcodeDialog(
      barcode: mBarcode,
      isAdd: isAdd,
      position: position,
      listener: this,
    );

    Get.bottomSheet(editBarcodeDialog!,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  void deleteBarcodeDialog(int position) {
    selectedPosition = position;
    AlertDialogHelper.showAlertDialog("", 'delete_item_msg'.tr, 'yes'.tr,
        'no'.tr, "", true, this, AppConstants.dialogIdentifier.deleteBarcode);
  }

  @override
  void onBarcodeSave(String barcode, bool add, int position) {
    var listBarcode = [];
    if(add){
      listBarcode.addAll(barcodeList);
    }else{
      for (int i = 0; i < barcodeList.length; i++) {
        if (i != position) {
          listBarcode.add(barcodeList[i]);
        }
      }
    }

    if (!listBarcode.contains(barcode)) {
      bool isBarcodeAvailable = false;
      if (AppStorage().getStockData() != null) {
        ProductListResponse response = AppStorage().getStockData()!;
        for (int i = 0; i < response.info!.length; i++) {
          ProductInfo item = response.info![i];
          int itemId = item.id ?? 0;
          String mBarCode = item.barcode_text ?? "";
          bool currentProduct = itemId == productId || itemId == localProductId;
          if (!currentProduct) {
            String enteredBarCode = barcode;
            if (!StringHelper.isEmptyString(enteredBarCode) &&
                mBarCode == enteredBarCode) {
              isBarcodeAvailable = true;
              break;
            }
          }
        }
      }
      if (isBarcodeAvailable) {
        AppUtils.showToastMessage('msg_barcode_already_exist'.tr);
      } else {
        if (add) {
          barcodeList.add(barcode);
        } else {
          barcodeList[position] = barcode;
        }
      }
    } else {
      AppUtils.showToastMessage('msg_barcode_already_exist'.tr);
    }
  }

  void onSubmitClick() {
    String mBarcodes = StringHelper.getCommaSeparatedStringIds(barcodeList);
    print("mBarcodes:" + mBarcodes);
    Get.back(result: mBarcodes);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteBarcode) {
      barcodeList.removeAt(selectedPosition);
      Get.back();
    }
  }

  void checkBarcodeAvailability(String newBarcode) {}
}
