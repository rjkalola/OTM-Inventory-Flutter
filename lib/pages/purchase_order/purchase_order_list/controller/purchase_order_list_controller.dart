import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/model/purchase_order_receive_request.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_repository.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/model/purchase_order_info.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/string_helper.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/base_response.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../stock_edit_quantiry/model/store_stock_request.dart';
import '../model/purchase_order_response.dart';

class PurchaseOrderListController extends GetxController {
  final _api = PurchaseOrderListRepository();
  var orderList = <PurchaseOrderInfo>[].obs;
  List<PurchaseOrderInfo> tempList = [];
  final searchController = TextEditingController().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs;
  final offset = 0.obs, totalPendingCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // setTotalCountButtons();
    loadData();
  }

  Future<void> loadData() async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      if (AppStorage().getPurchaseOrderList() != null) {
        setOfflineData();
        onCLickSyncData(false);
        // getPurchaseOrderListApi(false);
      } else {
        // getPurchaseOrderListApi(true);
        onCLickSyncData(true);
      }
    } else {
      setOfflineData();
    }
  }

  void getPurchaseOrderListApi(bool isProgress) async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getPurchaseOrders(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          PurchaseOrderResponse response =
              PurchaseOrderResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setPurchaseOrderList(response);
            setOfflineData();
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

  Future<void> storeLocalPurchaseOrderAPI(bool isProgress, String data) async {
    Map<String, dynamic> map = {};
    map["app_data"] = data;
    map["store_id"] = AppStorage.storeId.toString();
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    if (isProgress) isLoading.value = true;
    _api.storeLocalPurchaseOrderUrl(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (isProgress)
              AppUtils.showSnackBarMessage('msg_data_uploaded'.tr);
            AppStorage().clearStoredPurchaseOrderList();
            getPurchaseOrderListApi(isProgress);
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void setOfflineData() {
    isMainViewVisible.value = true;
    if (AppStorage().getPurchaseOrderList() != null) {
      PurchaseOrderResponse response = AppStorage().getPurchaseOrderList()!;
      tempList.clear();
      tempList.addAll(response.info!);
      orderList.value = tempList;
      orderList.refresh();
    }
    setTotalCountButtons();
  }

  Future<void> viewOrderDetails(PurchaseOrderInfo? info) async {
    var result;
    if (info != null) {
      var arguments = {
        AppConstants.intentKey.purchaseOrderInfo: info,
      };
      result = await Get.toNamed(AppRoutes.purchaseOrderDetailsScreen,
          arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.purchaseOrderDetailsScreen);
    }

    if (result != null && result) {
      loadData();
    }
  }

  Future<void> searchItem(String value) async {
    print("value:" + value);
    List<PurchaseOrderInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.supplierName) &&
                  element.supplierName!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.orderId) &&
                  element.orderId!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    print("results length:" + results.length.toString());
    orderList.value = results;
  }

  Future<void> onCLickSyncData(bool isProgress) async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      List<PurchaseOrderReceiveRequest> list =
          AppStorage().getStoredReceivedPurchaseOrderList();
      if (list.isNotEmpty) {
        storeLocalPurchaseOrderAPI(isProgress, jsonEncode(list));
      } else {
        getPurchaseOrderListApi(isProgress);
      }
    } else {
      if (isProgress) AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  // void uploadDataInAPI() {}

  void setTotalCountButtons() {
    totalPendingCount.value = localOrderCount();
    print("Pending Count:" + totalPendingCount.value.toString());
  }

  int localOrderCount() {
    List<PurchaseOrderReceiveRequest> list =
        AppStorage().getStoredReceivedPurchaseOrderList();
    return list.length;
  }
}
