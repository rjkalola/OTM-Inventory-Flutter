import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_history/stock_quantity_history_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../utils/AlertDialogHelper.dart';
import '../common/listener/DialogButtonClickListener.dart';
import '../stock_edit_quantiry/model/stock_qty_history_info.dart';
import 'model/stock_quantity_history_response.dart';

class StockQuantityHistoryController extends GetxController
    implements DialogButtonClickListener {
  final _api = StockQuantityHistoryRepository();
  String productId = "";
  final totalQuantity = "".obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final stockQuantityHistoryResponse = StockQuantityHistoryResponse().obs;
  final filterTab = AppConstants.stockFilterType.filterAll.obs;
  List<StockQtyHistoryInfo> tempList = [];
  final stockHistoryList = <StockQtyHistoryInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      productId = arguments[AppConstants.intentKey.productId]!;
      getStockQuantityHistoryApi(true, productId.toString());
    }
  }

  Future<void> getStockQuantityHistoryApi(
      bool isProgress, String productId) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["product_id"] = productId;
    multi.FormData formData = multi.FormData.fromMap(map);
    if (kDebugMode) print("map:" + map.toString());
    if (isProgress) isLoading.value = true;
    _api.getStockQuantityHistory(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StockQuantityHistoryResponse response =
              StockQuantityHistoryResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            stockQuantityHistoryResponse.value = response;
            tempList.clear();
            tempList.addAll(response.info!);
            stockHistoryList.value = tempList;
            totalQuantity.value = response.stock_qty ?? "";
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
            Get.back();
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

  void filterData(String filterType) {
    filterTab.value = filterType;
    List<StockQtyHistoryInfo> results = [];
    if (filterType == AppConstants.stockFilterType.filterAll) {
      results = tempList;
    } else if (filterType == AppConstants.stockFilterType.filterIn) {
      results =
          tempList.where((element) => int.parse(element.qty!) >= 0).toList();
    } else if (filterType == AppConstants.stockFilterType.filterOut) {
      results =
          tempList.where((element) => element.qty!.startsWith("-")).toList();
    }
    stockHistoryList.value = results;
  }

  void showNote(String note) {
    AlertDialogHelper.showAlertDialog("", note, 'ok'.tr, ''.tr, "", true, this,
        AppConstants.dialogIdentifier.quantityNote);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {}

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.quantityNote) {
      Get.back();
    }
  }
}
