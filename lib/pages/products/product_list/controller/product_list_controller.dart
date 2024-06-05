import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/product_list/controller/product_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../models/product_info.dart';
import '../models/product_list_response.dart';

class ProductListController extends GetxController {
  final _api = ProductListRepository();
  final searchController = TextEditingController().obs;

  final productListResponse = ProductListResponse().obs;
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLoadMore = false.obs;

  final filters = ''.obs, search = ''.obs;

  var offset = 0;
  var mIsLastPage = false;
  late ScrollController controller;

  @override
  void onInit() {
    super.onInit();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    getProductListApi(true, "0", true);
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !mIsLastPage) {
      print("reach the bottom");
      getProductListApi(false, "0", false);
    }
    // if (controller.offset <= controller.position.minScrollExtent &&
    //     !controller.position.outOfRange) {
    //   print("reach the top");
    // }
  }

  Future<void> addProductClick(ProductInfo? info) async {
    var result;
    if (info != null) {
      // var arguments = {
      //   AppConstants.intentKey.productInfo: info,
      // };
      var arguments = {
        AppConstants.intentKey.productId: info.id.toString(),
      };
      result = await Get.toNamed(AppRoutes.addStockProductScreen,
          arguments: arguments);
    } else {
      result = await Get.toNamed(AppRoutes.addStockProductScreen);
    }

    if (result != null && result) {
      getProductListApi(true, "0", true);
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

  Future<void> openQrCodeScanner() async {
    var result = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (result != null && !StringHelper.isEmptyString(result)) {
      getProductListApi(true, result, true);
    }
  }

  Future<void> getProductListApi(
      bool isProgress, String productId, bool clearOffset) async {
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
    map["product_id"] = productId;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (isProgress) isLoading.value = true;
    _api.getProductList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            isMainViewVisible.value = true;
            if (offset == 0) {
              tempList.clear();
              tempList.addAll(response.info!);
              productList.value = tempList;
              productList.refresh();
            } else if (response.info != null && response.info!.isNotEmpty) {
              tempList.addAll(response.info!);
              productList.value = tempList;
              productList.refresh();
            }

            offset = response.offset!;
            if (offset == 0) {
              mIsLastPage = true;
            } else {
              mIsLastPage = false;
            }

            print("tempList size:" + tempList.length.toString());
            print("productList size:" + productList.length.toString());
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
