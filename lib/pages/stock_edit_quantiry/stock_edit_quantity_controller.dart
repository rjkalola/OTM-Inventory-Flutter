import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/stock_quantity_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../utils/AlertDialogHelper.dart';
import '../../web_services/response/module_info.dart';
import '../add_store/model/store_resources_response.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/DialogButtonClickListener.dart';
import '../common/listener/select_item_listener.dart';
import '../products/add_product/model/store_product_response.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';
import '../stock_list/stock_list_repository.dart';

class StockEditQuantityController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final _api = StockEditQuantityRepository();
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final userController = TextEditingController().obs;
  final barcodeController = TextEditingController();
  final productInfo = ProductInfo().obs;
  String productId = "", mBarCode = "";
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int initialQuantity = 0, finalQuantity = 0, userId = 0;
  bool isUpdated = false;
  List<ModuleInfo> listUsers = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      productId = arguments[AppConstants.intentKey.productId]!;
      getStockQuantityDetailsApi(true, productId.toString());
    }
    getStoreResourcesApi();
  }

  Future<void> addStockClick(ProductInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.storeInfo: info,
      };
      result =
          await Get.toNamed(AppRoutes.addProductScreen, arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addProductScreen);
    }

    if (result != null && result) {
      // getStockListApi(true,"0");
    }
  }

  void showUsersList() {
    print("listUsers size:" + listUsers.length.toString());
    if (listUsers.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.usersList,
          'select_user'.tr, listUsers, this);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener,
            isCloseEnable: true),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.usersList) {
      userController.value.text = name;
      userId = id;
    }
  }

  void onClickQrCode() {
    if (!StringHelper.isEmptyString(productInfo.value.barcode_text)) {
      showUpdateBarcodeDialog();
    } else {
      showAttachBarcodeDialog();
    }
  }

  void onClickRemove() {
    AlertDialogHelper.showAlertDialog("", 'delete_stock_msg'.tr, 'yes'.tr,
        'no'.tr, "", true, this, AppConstants.dialogIdentifier.deleteStock);
  }

  Future<void> openQrCodeScanner(String message) async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      mBarCode = code;
      // getStockListApi(true, true, code);
      attachBarCodeApi(message);
    }
  }

  showAttachBarcodeDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'msg_attach_barcode'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.attachBarcodeDialog);
  }

  showUpdateBarcodeDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'msg_update_barcode'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.updateBarcodeDialog);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.attachBarcodeDialog) {
      Get.back();
      openQrCodeScanner('barcode_attached_success_msg'.tr);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.updateBarcodeDialog) {
      Get.back();
      openQrCodeScanner('barcode_update_success_msg'.tr);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.deleteStock) {
      Get.back();
      archiveStock(productInfo.value.id!);
    }
  }

  Future<void> getStockQuantityDetailsApi(
      bool isProgress, String productId) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["product_id"] = productId;
    multi.FormData formData = multi.FormData.fromMap(map);
    if (kDebugMode) print("map:" + map.toString());
    if (isProgress) isLoading.value = true;
    _api.getStockQuantityDetails(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StockQuantityDetailsResponse response =
              StockQuantityDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            productInfo.value = response.info!;
            // quantityController.value.text = productInfo.value.qty.toString();
            // quantityController.value.text = "0";
            initialQuantity = productInfo.value.qty ?? 0;
            finalQuantity = productInfo.value.qty ?? 0;
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
            Get.back();
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

  Future<void> storeStockQuantityApi(
      bool isProgress, String productId, String quantity, String note) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["product_id"] = productId;
    map["qty"] = quantity;
    map["user_id"] = userId;
    map["reference"] = note;
    multi.FormData formData = multi.FormData.fromMap(map);
    if (kDebugMode) print("map:" + map.toString());
    if (isProgress) isLoading.value = true;
    _api.storeStockQuantity(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            Get.back(result: true);
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

  void getStoreResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;

    _api.getStoreResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreResourcesResponse response = StoreResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            listUsers.clear();
            listUsers.addAll(response.users!);
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        // isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  Future<void> getStockListApi(
      bool isProgress, bool scanQrCode, String? code) async {
    Map<String, dynamic> map = {};
    map["filters"] = "";
    map["offset"] = 0;
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = "";
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    if (scanQrCode) {
      map["barcode_text"] = code;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    StockListRepository().getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (scanQrCode && response.info!.isEmpty) {
              showAttachBarcodeDialog();
            } else {
              showUpdateBarcodeDialog();
            }
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

  void attachBarCodeApi(String message) async {
    Map<String, dynamic> map = {};
    map["id"] = productId;
    map["barcode_text"] = mBarCode;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    StockListRepository().storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreProductResponse response =
              StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppUtils.showSnackBarMessage(message);
            isUpdated = true;
            getStockQuantityDetailsApi(true, productId.toString());
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void archiveStock(int id) async {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["store_id"] = AppStorage.storeId;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.archiveStock(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response = BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (!StringHelper.isEmptyString(response.Message ?? "")) {
              AppUtils.showToastMessage(response.Message ?? "");
            }
            Get.back(result: true);
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void onUpdateQuantityClick(bool isDeduct) {
    if (formKey.currentState!.validate()) {
      String note = noteController.value.text.toString().trim();
      int qty = int.parse(quantityController.value.text.toString().trim());
      int finalQty = 0;
      if (isDeduct) {
        finalQty = initialQuantity - qty;
      } else {
        finalQty = initialQuantity + qty;
      }
      storeStockQuantityApi(
          true, productId.toString(), finalQty.toString(), note);
    }
  }

  void onQuantityUpdate(String value) {
    int qty = 0;
    if (!StringHelper.isEmptyString(value)) {
      qty = int.parse(value);
    } else {
      qty = 0;
    }
    print("qty:$qty");
    finalQuantity = initialQuantity + qty;
    if (finalQuantity < 0) finalQuantity = 0;
    print("new qty:$finalQuantity");
  }

  showUpdateBarcodeManually(String barcode) {
    barcodeController.text = barcode;
    // set up the buttons
    List<Widget> listButtons = [];
    Widget cancelButton = TextButton(
      child: Text('update'.tr),
      onPressed: () {
        if (!StringHelper.isEmptyString(
            barcodeController.text.toString().trim())) {
          Get.back();
          mBarCode = barcodeController.text.toString().trim();
          attachBarCodeApi('barcode_update_success_msg'.tr);
        }
      },
    );
    listButtons.add(cancelButton);

    Widget positiveButton = TextButton(
      child: Text('cancel'.tr),
      onPressed: () {
        Get.back();
      },
    );
    listButtons.add(positiveButton);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'update_barcode'.tr,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      content: TextField(
          onChanged: (value) {},
          controller: barcodeController,
          decoration: InputDecoration(
              hintText: 'barcode'.tr,
              labelText: 'barcode'.tr,
              labelStyle: const TextStyle(fontWeight: FontWeight.normal),
              hintStyle: const TextStyle(fontWeight: FontWeight.normal))),
      actions: listButtons,
    );
    // show the dialog

    Get.dialog(barrierDismissible: true, alert);
  }
}
