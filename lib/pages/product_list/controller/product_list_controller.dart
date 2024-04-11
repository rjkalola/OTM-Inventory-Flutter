import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/product_list/controller/product_list_repository.dart';
import 'package:otm_inventory/pages/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/product_list/models/product_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';

class ProductListController extends GetxController {
  final _api = ProductListRepository();
  final searchController = TextEditingController().obs;

  final productListResponse = ProductListResponse().obs;
  var productList = <ProductInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getProductListApi();
  }

  void addProductClick()  {
    Get.toNamed(AppRoutes.addProductScreen);
    // var result = await Get.toNamed(AppRoutes.addProductScreen);
    // print("result"+result??false);
  }

  void getProductListApi() async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.value.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Data:"+map.toString());

    isLoading.value = true;
    _api.getProductList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
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
