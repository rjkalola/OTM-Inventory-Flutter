import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../utils/AlertDialogHelper.dart';
import '../../web_services/response/base_response.dart';
import '../../web_services/response/module_info.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/DialogButtonClickListener.dart';
import '../common/listener/select_item_listener.dart';
import '../products/add_product/model/add_product_request.dart';
import '../products/add_product/model/store_product_response.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';
import '../store_list/model/store_list_response.dart';

class StockListController extends GetxController implements DialogButtonClickListener
,SelectItemListener{
  final _api = StockListRepository();
  final searchController = TextEditingController().obs;
  var addProductRequest = AddProductRequest();
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;
  var storeList = <ModuleInfo>[].obs;
  final storeNameController = TextEditingController().obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,isScanQrCode = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;
  var mBarCode = "";

  @override
  void onInit() {
    super.onInit();
    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
    if (!StringHelper.isEmptyString(AppStorage.storeName)) {
      storeNameController.value.text = AppStorage.storeName;
    }
    getStoreListApi();
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    productList.value = results;
  }

  Future<void> openQrCodeScanner() async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      mBarCode = code;
      // moveStockEditQuantityScreen(productId);
      getStockListApi(true, true, code);
    }
  }

  Future<void> moveStockEditQuantityScreen(String? productId) async {
    var result;
    if (productId != null) {
      var arguments = {
        AppConstants.intentKey.productId: productId,
      };
      result =
      await Get.toNamed(AppRoutes.stockEditQuantityScreen, arguments: arguments);
    }

    if(isScanQrCode.value){
      mBarCode = "";
      getStockListApi(true,false,"");
    }else{
      if (result != null && result) {
        getStockListApi(true,false,"");
      }
    }

  }

  Future<void> addStockProductScreen() async {
    var result;
    if (!StringHelper.isEmptyString(mBarCode)) {
      var arguments = {
        AppConstants.intentKey.barCode: mBarCode,
      };
      result =
      await Get.toNamed(AppRoutes.addStockProductScreen, arguments: arguments);
    }

    if (result != null && result) {
      mBarCode = "";
      isScanQrCode.value = false;
      getStockListApi(true,false,"");
    }

  }

  void onClickSelectButton(ProductInfo info ){
    addProductRequest = AddProductRequest();
    addProductRequest.categories = [];
    addProductRequest.id = info.id ?? 0;
    addProductRequest.supplier_id = info.supplierId ?? 0;
    addProductRequest.lengthUnit_id = info.length_unit_id ?? 0;
    addProductRequest.weightUnit_id = info.weight_unit_id ?? 0;
    addProductRequest.manufacturer_id = info.manufacturer_id ?? 0;
    addProductRequest.model_id = info.model_id ?? 0;
    if (info.categories != null && info.categories!.isNotEmpty) {
      for (int i = 0; i < info.categories!.length; i++) {
        addProductRequest.categories!.add(info.categories![i].id.toString());
      }
    }
    addProductRequest.shortName = info.shortName ?? "";
    addProductRequest.name = info.name ?? "";
    addProductRequest.length = info.length ?? "";
    addProductRequest.width = info.width ?? "";
    addProductRequest.height = info.height ?? "";
    addProductRequest.weight = info.weight ?? "";
    addProductRequest.sku = info.sku ?? "";
    addProductRequest.price = info.price ?? "";
    addProductRequest.tax= info.tax ?? "";
    addProductRequest.description = info.description ?? "";
    addProductRequest.status = info.status ?? false;

    storeProductApi();
  }

  showAddStockProductDialog(){
    AlertDialogHelper.showAlertDialog(
        "",
        'empty_qr_code_scan_msg'.tr,
        'attach_product'.tr,
        'cancel'.tr,
        "add_new_product".tr,
        true,
        this,
        AppConstants.dialogIdentifier.stockOptionsDialog);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    if(dialogIdentifier == AppConstants.dialogIdentifier.stockOptionsDialog){
      Get.back();
      addStockProductScreen();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if(dialogIdentifier == AppConstants.dialogIdentifier.stockOptionsDialog){
      getStockListWithCodeApi(true, true, "null");
      Get.back();
    }
  }

  Future<void> getStockListApi(bool isProgress,bool scanQrCode,String? code) async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.value.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    if(scanQrCode){
      map["barcode_text"] = code;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if(scanQrCode && response.info!.isEmpty){
              showAddStockProductDialog();
              // getStockListWithCodeApi(isProgress, true, "null");
            }else{
              print("response.info! size:"+response.info!.length.toString());

              isScanQrCode.value = false;
              tempList.clear();
              tempList.addAll(response.info!);
              // productList.addAll(tempList);
              productList.value = tempList;
              productList.refresh();
              isMainViewVisible.value = true;
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

  Future<void> getStockListWithCodeApi(bool isProgress,bool scanQrCode,String? code) async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.value.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    if(scanQrCode){
      map["barcode_text"] = code;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
          ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
              isScanQrCode.value = scanQrCode;
              tempList.clear();
              tempList.addAll(response.info!);
              productList.value = tempList;
              isMainViewVisible.value = true;
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

  void storeProductApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addProductRequest.id;
    /*map["shortName"] = addProductRequest.shortName;
    map["name"] = addProductRequest.name;
    map["supplier_id"] = addProductRequest.supplier_id;
    map["length"] = addProductRequest.length;
    map["width"] = addProductRequest.width;
    map["height"] = addProductRequest.height;
    map["length_unit_id"] = addProductRequest.lengthUnit_id;
    map["weight"] = addProductRequest.weight;
    map["weight_unit_id"] = addProductRequest.weightUnit_id;
    map["manufacturer_id"] = addProductRequest.manufacturer_id;
    map["model_id"] = addProductRequest.model_id;
    map["sku"] = addProductRequest.sku;
    map["price"] = addProductRequest.price;
    map["tax"] = addProductRequest.tax;
    map["description"] = addProductRequest.description;
    map["status"] = addProductRequest.status;
    map["mode_type"] = 2;
    if (addProductRequest.categories != null &&
        addProductRequest.categories!.isNotEmpty) {
      for (int i = 0; i < addProductRequest.categories!.length; i++) {
        map['categories[${i.toString()}]'] = addProductRequest.categories![i];
      }
    }*/
    map["barcode_text"] = mBarCode;
    multi.FormData formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreProductResponse response = StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            moveStockEditQuantityScreen(response.info!.id.toString());
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

  //For Select Store Dropdown
  void selectStore() {
    if (storeList.isNotEmpty) {
      showStoreListDialog(AppConstants.dialogIdentifier.storeList, 'stores'.tr,
          storeList, true, true, true,true, this);
    } else {
      AppUtils.showSnackBarMessage('empty_store_message'.tr);
    }
  }

  void showStoreListDialog(
      String dialogType,
      String title,
      List<ModuleInfo> list,
      bool enableDrag,
      bool isDismiss,
      bool canPop,
      bool isClose,
      SelectItemListener listener) {
    Get.bottomSheet(
        enableDrag: enableDrag,
        isDismissible: isDismiss,
        PopScope(
          canPop: canPop,
          child: DropDownListDialog(
              title: title,
              dialogType: dialogType,
              list: list,
              listener: listener,
              isCloseEnable: isClose),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.storeList) {
      AppStorage.storeId = id;
      AppStorage.storeName = name;
      storeNameController.value.text = name;
      Get.find<AppStorage>().setStoreId(id);
      Get.find<AppStorage>().setStoreName(name);
      getStockListApi(true,false,"");
    }
  }

  void getStoreListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.getStoreList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreListResponse response =
          StoreListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (response.info != null && response.info!.isNotEmpty) {
              storeList.clear();
              for (int i = 0; i < response.info!.length; i++) {
                ModuleInfo info = ModuleInfo();
                info.id = response.info![i].id;
                info.name = response.info![i].storeName!;
                storeList.add(info);
              }
            }
            if (AppStorage.storeId == 0 && storeList.isNotEmpty) {
              showStoreListDialog(AppConstants.dialogIdentifier.storeList,
                  'stores'.tr, storeList, false, false, false,false, this);
            } else {
              getStockListApi(true,false,"");
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

}
