import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_repository.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/model/purchase_order_info.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/string_helper.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
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
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getPurchaseOrderListApi(true);
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
            tempList.clear();
            tempList.addAll(response.info!);
            orderList.value = tempList;
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
      getPurchaseOrderListApi(true);
    }
  }

  Future<void> searchItem(String value) async {
    print("value:"+value);
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
    print("results length:"+results.length.toString());
    orderList.value = results;
  }
}
