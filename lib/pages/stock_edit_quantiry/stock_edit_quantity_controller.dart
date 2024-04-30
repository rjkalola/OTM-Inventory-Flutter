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
import '../../web_services/response/module_info.dart';
import '../add_store/model/store_resources_response.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/select_item_listener.dart';
import '../products/product_list/models/product_info.dart';

class StockEditQuantityController extends GetxController
    implements SelectItemListener {
  final _api = StockEditQuantityRepository();
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final userController = TextEditingController().obs;
  final productInfo = ProductInfo().obs;
  String productId = "";
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int initialQuantity = 0, finalQuantity = 0, userId = 0;
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
    print("listUsers size:"+listUsers.length.toString());
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
    map["note"] = note;
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

  void onUpdateQuantityClick(bool isDeduct) {
    if (formKey.currentState!.validate()) {
      String note = noteController.value.text.toString().trim();
      // String qtyString = finalQuantity.toString();
      // storeStockQuantityApi(true, productId.toString(),qtyString,note);

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

  void increaseQuantity() {
    String qtyString = quantityController.value.text.toString().trim();
    int quantity = 0;
    if (!StringHelper.isEmptyString(qtyString)) quantity = int.parse(qtyString);
    quantity++;
    quantityController.value.text = quantity.toString();
    onQuantityUpdate(quantity.toString());
  }

  void decreaseQuantity() {
    String qtyString = quantityController.value.text.toString().trim();
    int quantity = 0;
    if (!StringHelper.isEmptyString(qtyString)) quantity = int.parse(qtyString);
    // if (quantity > 1) quantity--;
    quantity--;
    quantityController.value.text = quantity.toString();
    onQuantityUpdate(quantity.toString());
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
}
