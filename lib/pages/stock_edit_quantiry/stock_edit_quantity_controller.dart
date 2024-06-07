import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/stock_quantity_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/store_stock_request.dart';
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
import '../../utils/date_utils.dart';
import '../../web_services/response/module_info.dart';
import '../add_store/model/store_resources_response.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/DialogButtonClickListener.dart';
import '../common/listener/select_date_listener.dart';
import '../common/listener/select_item_listener.dart';
import '../products/add_product/model/store_product_response.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';
import '../stock_list/stock_list_repository.dart';

class StockEditQuantityController extends GetxController
    implements
        SelectItemListener,
        DialogButtonClickListener,
        SelectDateListener {
  final _api = StockEditQuantityRepository();
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final userController = TextEditingController().obs;
  final barcodeController = TextEditingController();
  final dateController = TextEditingController().obs;
  final priceController = TextEditingController().obs;
  final productInfo = ProductInfo().obs;
  String productId = "", mBarCode = "";
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDeductQtyVisible = false.obs,
      isAddQtyVisible = true.obs,
      isUserDropdownVisible = false.obs,
      isReferenceVisible = true.obs;
  int initialQuantity = 0, finalQuantity = 0, userId = 0;
  bool isUpdated = false;
  List<ModuleInfo> listUsers = [];
  DateTime selectedDate = DateTime.now();

  @override
  Future<void> onInit() async {
    super.onInit();
    var arguments = Get.arguments;
    // quantityController.value.text = "1";
    if (!StringHelper.isEmptyString(Get.find<AppStorage>().getQuantityNote())) {
      noteController.value.text = Get.find<AppStorage>().getQuantityNote();
    }

    /* bool isInternet = await AppUtils.interNetCheck();
    print("isInternet:" + isInternet.toString());
    if (arguments != null) {
      if (isInternet) {
        productId = arguments[AppConstants.intentKey.productId]!;
        getStockQuantityDetailsApi(true, productId.toString());
      } else {
        print("1111111111");
        productId = arguments[AppConstants.intentKey.productId]!;
        ProductInfo? info = arguments[AppConstants.intentKey.productInfo];
        print("Name" + info!.name!);
        setProductInfo(info);
      }
    }
    if (isInternet) {
      getStoreResourcesApi();
    } else {
      if (AppStorage().getStockResources() != null) {
        StoreResourcesResponse response = AppStorage().getStockResources()!;
        listUsers.clear();
        listUsers.addAll(response.users!);
        // print("Name:${item.name!}");
      }
    }*/

    productId = arguments[AppConstants.intentKey.productId]!;
    ProductInfo? info = arguments[AppConstants.intentKey.productInfo];
    setProductInfo(info);

    if (AppStorage().getStockResources() != null) {
      StoreResourcesResponse response = AppStorage().getStockResources()!;
      listUsers.clear();
      listUsers.addAll(response.users!);
    }
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
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.deleteStock) {
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
            setProductInfo(response.info);
            // productInfo.value = response.info!;
            // // quantityController.value.text = productInfo.value.qty.toString();
            // // quantityController.value.text = "0";
            // initialQuantity = productInfo.value.qty ?? 0;
            // finalQuantity = productInfo.value.qty ?? 0;
            // isMainViewVisible.value = true;
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

  void setProductInfo(ProductInfo? info) {
    if (info != null) {
      productInfo.value = info;
      initialQuantity = productInfo.value.qty ?? 0;
      finalQuantity = productInfo.value.qty ?? 0;
      isMainViewVisible.value = true;
    }
  }

  Future<void> storeStockQuantityApi(
      bool isProgress,
      String productId,
      String quantity,
      String note,
      String price,
      String date,
      String mode) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["product_id"] = productId;
    map["qty"] = quantity;
    if (isUserDropdownVisible.value) {
      map["user_id"] = userId;
    }
    if (isReferenceVisible.value) {
      map["reference"] = note;
    }
    map["price"] = price;
    map["date"] = date;
    map["mode"] = mode;

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
            Get.find<AppStorage>().setQuantityNote(note);
            AppUtils.showSnackBarMessage(response.Message!);
            // Get.back(result: true);
            isUpdated = true;
            getStockQuantityDetailsApi(true, productId);
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
            AppStorage().setStockResources(response);
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
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
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

  Future<void> onUpdateQuantityClick(bool isDeduct) async {
    if (formKey.currentState!.validate()) {
      String note = noteController.value.text.toString().trim();
      String qtyString = quantityController.value.text.toString().trim();
      if (qtyString.startsWith("+") || qtyString.startsWith("-")) {
        qtyString = qtyString.substring(1, qtyString.length);
      }
      int qty = int.parse(qtyString);
      int finalQty = 0;
      // if (isDeduct) {
      //   finalQty = initialQuantity - qty;
      // } else {
      //   finalQty = initialQuantity + qty;
      // }

      if (isDeduct) {
        finalQty = -qty;
      } else {
        finalQty = qty;
      }

      String price = priceController.value.text.toString().trim();
      String date = dateController.value.text.toString().trim();

      // bool isInternet = await AppUtils.interNetCheck();
      // if (isInternet) {
      //   storeStockQuantityApi(true, productId.toString(), finalQty.toString(),
      //       note, price, date, isDeduct ? "remove" : "add");
      // } else {
      // Add stock in local storage
      List<StockStoreRequest> list = AppStorage().getStoredStockList();
      StockStoreRequest request = StockStoreRequest();
      request.product_id = productId.toString();
      request.store_id = AppStorage.storeId.toString();
      request.qty = finalQty.toString();
      if (isUserDropdownVisible.value) {
        request.user_id = userId.toString();
      }
      if (isReferenceVisible.value) {
        request.note = note;
      }
      request.mode = isDeduct ? "remove" : "add";
      list.add(request);
      AppStorage().setStoredStockList(list);

      productInfo.value.qty = productInfo.value.qty != null
          ? (productInfo.value.qty! + finalQty)
          : finalQty;
      productInfo.refresh();

      //Update list quantity
      if (AppStorage().getStockData() != null) {
        ProductListResponse response = AppStorage().getStockData()!;
        if (!StringHelper.isEmptyList(response.info)) {
          for (int i = 0; i < response.info!.length; i++) {
            if (response.info![i].id.toString() == productId) {
              response.info![i].qty = productInfo.value.qty;
              break;
            }
          }
        }
        AppStorage().setStockData(response);
      }

      AppUtils.showToastMessage('msg_product_stock_update'.tr);
      Get.back(result: true);

      // isUpdated = true;
      // }
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

  void showDatePickerDialog() {
    DateUtil.showDatePickerDialog(selectedDate, DateTime(1950), DateTime(2100),
        AppConstants.dialogIdentifier.selectDate, this);
  }

  // Future<void> showDatePickerDialog() async {
  //   final DateTime? picked = await showDatePicker(
  //       context: Get.context!,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(1950),
  //       lastDate: DateTime(2100));
  //   if (picked != null && picked != selectedDate) {
  //     print(DateUtil.dateToString(picked, DateUtil.DD_MMM_YYYY_SPACE));
  //     selectedDate = picked;
  //   }
  // }

  Future<void> editProductClick() async {
    var arguments = {
      AppConstants.intentKey.productInfo: productInfo.value,
      AppConstants.intentKey.productId: productId
    };
    var result =
        await Get.toNamed(AppRoutes.addStockProductScreen, arguments: arguments);
    if (result != null && result) {
      Get.back(result: true);
    }
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    dateController.value.text =
        DateUtil.dateToString(date, DateUtil.YYYY_MM_DD_DASH);
    print("Output Date::" +
        DateUtil.dateToString(date, DateUtil.YYYY_MM_DD_DASH));
  }
}
