import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';

class StockListController extends GetxController {
  final _api = StockListRepository();
  final searchController = TextEditingController().obs;
  final productListResponse = ProductListResponse().obs;
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getStockListApi(true, "0");
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
      getStockListApi(true, "0");
    }
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
    var productId = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (productId != null && !StringHelper.isEmptyString(productId)) {
      var result;
      if (productId != null) {
        var arguments = {
          AppConstants.intentKey.productId: productId,
        };
        result =
        await Get.toNamed(AppRoutes.stockEditQuantityScreen, arguments: arguments);
      }

      if (result != null && result) {
        getStockListApi(true,"0");
      }

    }
  }

  Future<void> getStockListApi(bool isProgress, String productId) async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.value.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = productId;
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            productListResponse.value = response;
            tempList.clear();
            tempList.addAll(response.info!);
            // productList.clear();
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
}
