import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:get/get.dart';
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
  List<StoreInfo> tempList = [];

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getStoreListApi(true);
  }

  void getStoreListApi(bool isProgress) async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getStoreList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreListResponse response =
              StoreListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            tempList.clear();
            tempList.addAll(response.info!);
            storeList.value = tempList;
            isMainViewVisible.value = true;
            print("Array Lenth:" + response.info!.length.toString());
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

  Future<void> addStoreClick(StoreInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.storeInfo: info,
      };
      result =
          await Get.toNamed(AppRoutes.addStoreScreen, arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addStoreScreen);
    }

    if (result != null && result) {
      getStoreListApi(true);
    }
  }

  Future<void> searchItem(String value) async{
    List<StoreInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    }else{
      results = tempList.where((element) => element.storeName!.toLowerCase().contains(value.toLowerCase())).toList();
    }
    storeList.value = results;
  }
}
