import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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

class StoreListController extends GetxController {
  final _api = StoreListRepository();
  var storeList = <StoreInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getStoreListApi();
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
            storeList.clear();
            storeList.addAll(response.info!);
            isMainViewVisible.value = true;
            print("Array Lenth:"+response.info!.length.toString());
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
