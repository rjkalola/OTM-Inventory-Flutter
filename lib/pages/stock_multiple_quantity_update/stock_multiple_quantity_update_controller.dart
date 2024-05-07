import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/model/add_quantity_request.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../web_services/response/module_info.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';

class StockMultipleQuantityUpdateController extends GetxController {
  final _api = StockListRepository();
  final searchController = TextEditingController().obs;
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;
  final controllers = <TextEditingController>[].obs;
  var storeList = <ModuleInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLoadMore = false.obs;

  final filters = ''.obs, search = ''.obs;
  var mBarCode = "";
  var mIsLastPage = false;
  late ScrollController controller;
  var offset = 0;

  @override
  void onInit() {
    super.onInit();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    getStockListApi(true, true);
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].dispose();
    }
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !mIsLastPage) {
      getStockListApi(false, false);
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      // setState(() {
      //   message = "reach the top";
      // });
    }
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    productList.value = results;
  }

  void onClickAddQuantityButton() {
    List<AddQuantityRequest> listQty = [];
    for (int i = 0; i < productList.length; i++) {
      AddQuantityRequest info = AddQuantityRequest();
      int qty = 0;
      if (productList[i].qty != null) qty = productList[i].qty!;
      if (productList[i].newQty != null) qty = qty + productList[i].newQty!;
      info.qty = qty;
      info.store_id = AppStorage.storeId.toString();
      info.product_id = productList[i].id;
      listQty.add(info);
    }
    if (kDebugMode) print(jsonEncode(listQty));
    addStockApi(true, jsonEncode(listQty));
  }

  Future<void> getStockListApi(bool isProgress, bool clearOffset) async {
    if (clearOffset) {
      offset = 0;
      mIsLastPage = false;
    }
    isLoadMore.value = offset > 0;
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    // map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            /* tempList.clear();
            tempList.addAll(response.info!);
            controllers.clear();
            for (int i = 0; i < response.info!.length; i++) {
              controllers.add(TextEditingController());
            }
            productList.value = tempList;
            isMainViewVisible.value = true;*/

            isMainViewVisible.value = true;
            if (offset == 0) {
              tempList.clear();
              tempList.addAll(response.info!);
              controllers.clear();
              for (int i = 0; i < response.info!.length; i++) {
                controllers.add(TextEditingController());
              }
              productList.value = tempList;
              productList.refresh();
            } else if (response.info != null && response.info!.isNotEmpty) {
              tempList.addAll(response.info!);
              for (int i = 0; i < response.info!.length; i++) {
                controllers.add(TextEditingController());
              }
              productList.value = tempList;
              productList.refresh();
            }

            offset = response.offset!;
            if (offset == 0) {
              mIsLastPage = true;
            } else {
              mIsLastPage = false;
            }
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

  Future<void> addStockApi(bool isProgress, String data) async {
    Map<String, dynamic> map = {};
    map["product_data"] = data;
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.addStock(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            Get.back(result: true);
            if (!StringHelper.isEmptyString(response.Message))
              AppUtils.showSnackBarMessage(response.Message ?? "");
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
