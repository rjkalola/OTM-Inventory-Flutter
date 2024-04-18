import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/category_list/category_list_repository.dart';
import 'package:otm_inventory/pages/category_list/model/category_info.dart';
import 'package:otm_inventory/pages/category_list/model/category_list_response.dart';
import 'package:otm_inventory/pages/product_list/controller/product_list_repository.dart';
import 'package:otm_inventory/pages/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/product_list/models/product_list_response.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_repository.dart';
import 'package:otm_inventory/pages/store_list/model/store_info.dart';
import 'package:otm_inventory/pages/store_list/model/store_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';

class CategoryListController extends GetxController {
  final _api = CategoryListRepository();
  var categoryList = <CategoryInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCategoryListApi(true);
  }

  Future<void> searchItem(String value) async {
    print(value);
    print("categoryList length:"+categoryList.length.toString());
  }

  void getCategoryListApi(bool isProgress) async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    if (isProgress) isLoading.value = true;
    _api.getCategoryList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          CategoryListResponse response = CategoryListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            categoryList.clear();
            categoryList.addAll(response.info!);
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

  Future<void> addCategoryClick(CategoryInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.categoryInfo: info,
      };
      result =
          await Get.toNamed(AppRoutes.addCategoryScreen, arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addCategoryScreen);
    }

    if (result != null && result) {
      getCategoryListApi(true);
    }
  }
}
