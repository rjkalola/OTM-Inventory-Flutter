import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/model/feed_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/model/feed_list_response.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class FeedController extends GetxController {
  final _api = FeedRepository();
  final searchController = TextEditingController().obs;

  var itemList = <FeedInfo>[].obs;
  List<FeedInfo> tempList = [];

  RxBool isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs;
  final dashboardController = Get.put(DashboardController());

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getFeedList(true);
  }

  void getFeedList(bool isProgress) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["limit"] = 20;
    map["offset"] = 0;
    map["feed_type"] = 2;
    map["is_inventory"] = 1;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) dashboardController.isLoading.value = true;

    _api.getFeedList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        dashboardController.isLoading.value = false;
        if (responseModel.statusCode == 200) {
          FeedListResponse response =
              FeedListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            tempList.clear();
            tempList.addAll(response.info!);
            itemList.value = tempList;
            print("itemList.value length:" + itemList.value.toString());
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        dashboardController.isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  Future<void> searchItem(String value) async {
    print("Search item:" + value);
    List<FeedInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              element.message!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    itemList.value = results;
  }
}
