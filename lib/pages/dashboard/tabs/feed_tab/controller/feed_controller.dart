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
      isClearVisible = false.obs,
      isLoadMore = false.obs,
      isLoading = false.obs;

  final dashboardController = Get.put(DashboardController());

  final filters = ''.obs, search = ''.obs;
  var offset = 0;

  var mIsLastPage = false;
  late ScrollController controller;

  @override
  void onInit() {
    super.onInit();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    getFeedList(true, false);
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !mIsLastPage) {
      getFeedList(false, false);
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {}
  }

  Future<void> getFeedList(bool isProgress, bool clearOffset) async {
    if (clearOffset) {
      offset = 0;
      mIsLastPage = false;
    }
    isLoadMore.value = offset > 0;
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["limit"] = 10;
    map["offset"] = offset;
    map["feed_type"] = 2;
    map["is_inventory"] = 1;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;

    _api.getFeedList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          FeedListResponse response =
              FeedListResponse.fromJson(jsonDecode(responseModel.result!));
          /* if (response.isSuccess!) {
            tempList.clear();
            tempList.addAll(response.info!);
            itemList.value = tempList;
            print("itemList.value length:" + itemList.value.toString());
            isMainViewVisible.value = true;
          }*/
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            if (offset == 0) {
              tempList.clear();
              tempList.addAll(response.info!);
              itemList.value = tempList;
              itemList.refresh();
            } else if (response.info != null && response.info!.isNotEmpty) {
              tempList.addAll(response.info!);
              itemList.value = tempList;
              itemList.refresh();
            }

            offset = response.offset!;
            if (offset == 0) {
              mIsLastPage = true;
            } else {
              mIsLastPage = false;
            }
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isLoadMore.value = false;
        isMainViewVisible.value = false;
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
