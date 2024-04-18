import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/product_list/controller/product_list_repository.dart';
import 'package:otm_inventory/pages/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/product_list/models/product_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';

class ProductListController extends GetxController {
  final _api = ProductListRepository();
  final searchController = TextEditingController().obs;

  final productListResponse = ProductListResponse().obs;
  // List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;


  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getProductListApi(true,"0");
  }

  Future<void> addProductClick(ProductInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.productInfo: info,
      };
      result =
          await Get.toNamed(AppRoutes.addProductScreen, arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addProductScreen);
    }

    if (result != null && result) {
      getProductListApi(true,"0");
    }
  }

  Future<void> searchItem(String value) async{
    print(value);
    List<ProductInfo> results = [];
    // if (value.isEmpty) {
    //   results = tempList;
    // }else{
    //   results = tempList.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    // }

    // print("productList lenth:"+productList.length.toString());

   /* if (productList.isNotEmpty) {
      results = tempList.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
      print("Contacts list is not empty");
      // results.clear(); // Clear previous search results
      // for (ProductInfo info in productList) {
      //   if (info.name!.toLowerCase().contains(value.toLowerCase())) {
      //     results.add(info); // Add the contact to the searchResults list
      //   }
      // }
      print(results.isEmpty ? "Search result is empty" : "Found ${results.length} results");
    } else {
      print("productList is empty");
    }*/

    // ProductInfo info = ProductInfo();
    // info.name = "Testttt";
    // productList.add(info);
    // productList.refresh();

    // productList[0].name = "Test Refresh";
    // productList.refresh();
  }

  Future<void> openQrCodeScanner() async {
    var result = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (result != null && !StringHelper.isEmptyString(result)) {
      getProductListApi(true,result);
    }
  }

  Future<void> getProductListApi(bool isProgress, String productId) async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.value.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = productId;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getProductList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            productListResponse.value = response;
            // tempList.clear();
            // tempList.addAll(response.info!);
            productList.clear();
            productList.addAll(response.info!);
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
