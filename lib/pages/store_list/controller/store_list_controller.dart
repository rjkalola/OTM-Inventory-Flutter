import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_repository.dart';
import 'package:otm_inventory/pages/store_list/model/store_info.dart';
import 'package:otm_inventory/pages/store_list/model/store_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/base_response.dart';
import '../../../web_services/response/response_model.dart';
import '../../common/model/file_info.dart';
import '../../products/add_product/controller/add_product_repository.dart';
import '../../products/product_list/models/product_info.dart';
import '../../products/product_list/models/product_list_response.dart';
import '../../stock_edit_quantiry/model/store_stock_request.dart';
import '../../stock_list/stock_list_repository.dart';

class StoreListController extends GetxController {
  final _api = StoreListRepository();
  var storeList = <StoreInfo>[].obs;
  List<StoreInfo> tempList = [];
  final searchController = TextEditingController().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs;

  final filters = ''.obs, search = ''.obs;
  final offset = 0.obs, activeStoreId = 0.obs;
  int selectedStorePosition = -1;

  @override
  void onInit() {
    super.onInit();
    activeStoreId.value = AppStorage.storeId;
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

  Future<void> searchItem(String value) async {
    List<StoreInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              element.storeName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    storeList.value = results;
  }

  Future<void> getAllStockListApi() async {
    // isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["filters"] = "";
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    map["allData"] = "true";

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    StockListRepository().getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockData(response);
            activeStoreId.value = AppStorage.storeId;
            AppUtils.showSnackBarMessage(
                "${storeList[selectedStorePosition].storeName} Activated");
          } else {
            // if (isProgress) AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // if (isProgress)
          //   AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalStocksAPI(String data, int productCount) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["app_data"] = data;
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    // if (isProgress) isLoading.value = true;
    StockListRepository().storeLocalStock(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (productCount > 0) {
              AppStorage().clearStoredStock();
              storeLocalProducts(getLocalStoredProduct());
            } else {
              AppStorage().clearStoredStock();
              AppStorage().clearStoredProduct();
              updateStoreData();
            }
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalProducts(List<ProductInfo> listProducts) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["data"] = jsonEncode(listProducts);
    multi.FormData formData = multi.FormData.fromMap(map);
    for (int i = 0; i < listProducts.length; i++) {
      var listFiles = <FilesInfo>[];
      if (!StringHelper.isEmptyList(listProducts[i].temp_images)) {
        for (int j = 0; j < listProducts[i].temp_images!.length; j++) {
          if (!StringHelper.isEmptyString(
                  listProducts[i].temp_images![j].file ?? "") &&
              !listProducts[i].temp_images![j].file!.startsWith("http")) {
            listFiles.add(listProducts[i].temp_images![j]);
          }
        }
      }
      if (listFiles.isNotEmpty) {
        for (var info in listFiles) {
          formData.files.addAll([
            MapEntry("files[$i][]",
                await multi.MultipartFile.fromFile(info.file ?? "")),
          ]);
        }
      }
    }

    print(map.toString());
    // if (isProgress) isLoading.value = true;
    AddProductRepository().storeMultipleProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().clearStoredStock();
            AppStorage().clearStoredProduct();
            updateStoreData();
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

  List<ProductInfo> getLocalStoredProduct() {
    List<ProductInfo> listProducts = [];
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            listProducts.add(response.info![i]);
          }
        }
      }
    }
    return listProducts;
  }

  int localStockCount() {
    List<StockStoreRequest> list = AppStorage().getStoredStockList();
    return list.length;
  }

  int localProductCount() {
    int count = 0;
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        List<ProductInfo> list = [];
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            list.add(response.info![i]);
          }
        }
        count = list.length;
      }
    }
    return count;
  }

  Future<void> onCLickStoreChange(int storePosition) async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      isLoading.value = true;
      selectedStorePosition = storePosition;
      int productCount = localProductCount();
      int stockCount = localStockCount();
      if (stockCount > 0) {
        List<StockStoreRequest> list = AppStorage().getStoredStockList();
        storeLocalStocksAPI(jsonEncode(list), productCount);
      } else if (productCount > 0) {
        storeLocalProducts(getLocalStoredProduct());
      } else {
        updateStoreData();
      }
    } else {
      AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  updateStoreData() {
    AppStorage.storeId = storeList[selectedStorePosition].id!;
    AppStorage.storeName = storeList[selectedStorePosition].storeName!;
    Get.find<AppStorage>().setStoreId(AppStorage.storeId);
    Get.find<AppStorage>().setStoreName(AppStorage.storeName);
    getAllStockListApi();
  }
}
