import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/products/add_product/controller/add_product_repository.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_repository.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_repository.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_info.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_list_response.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_list_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/store_stock_request.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../common/model/file_info.dart';

class OrderListController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs;
  final search = ''.obs, fromDate = ''.obs, toDate = ''.obs;
  final offset = 0.obs;
  final _api = OrderListRepository();
  final searchController = TextEditingController().obs;
  late ScrollController scrollController;
  var itemList = <OrderInfo>[].obs;
  List<OrderInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    getInventoryOrderList(true);
    var arguments = Get.arguments;
    if (arguments != null) {
      // title.value = 'edit_product'.tr;
      // productId = arguments[AppConstants.intentKey.productId];
      // getProductDetails(productId);
    }
  }

  void getInventoryOrderList(bool isProgress) async {
    if (isProgress) isLoading.value = true;

    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();

    var formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());
    _api.inventoryOrderList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          OrderListResponse response =
              OrderListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            tempList.clear();
            tempList.addAll(response.info!);
            itemList.value = tempList;
            isMainViewVisible.value = true;
            fromDate.value = response.fromDate ?? "";
            toDate.value = response.toDate ?? "";
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
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
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (element.orderedUserName ?? "")
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    itemList.value = results;
  }
}
