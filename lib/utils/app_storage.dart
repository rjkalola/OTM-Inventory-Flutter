import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/dashboard/models/permission_response.dart';
import 'package:otm_inventory/pages/products/add_product/model/add_product_request.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/add_store/model/store_resources_response.dart';
import '../pages/dashboard/models/dashboard_stock_count_response.dart';
import '../pages/otp_verification/model/user_info.dart';
import '../pages/products/add_product/model/product_resources_response.dart';
import '../pages/products/product_list/models/product_list_response.dart';
import '../pages/stock_edit_quantiry/model/store_stock_request.dart';
import '../pages/stock_filter/model/stock_filter_response.dart';

class AppStorage extends GetxController {
  final storage = GetStorage();
  static int storeId = 0;
  static String storeName = "";
  static String uniqueId = "";

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void setUserInfo(UserInfo info) {
    storage.write(AppConstants.sharedPreferenceKey.userInfo, info.toJson());
  }

  UserInfo getUserInfo() {
    final map = storage.read(AppConstants.sharedPreferenceKey.userInfo) ?? {};
    return UserInfo.fromJson(map);
  }

  void setLoginUsers(List<UserInfo> list) {
    storage.write(
        AppConstants.sharedPreferenceKey.savedLoginUserList, jsonEncode(list));
  }

  List<UserInfo> getLoginUsers() {
    final jsonString =
        storage.read(AppConstants.sharedPreferenceKey.savedLoginUserList) ?? "";
    if (!StringHelper.isEmptyString(jsonString)) {
      final jsonMap = json.decode(jsonString);
      List<UserInfo> list = (jsonMap as List)
          .map((itemWord) => UserInfo.fromJson(itemWord))
          .toList();
      // List<UserInfo> list = (jsonDecode(jsonString) as List<dynamic>).cast<UserInfo>();
      return list;
    } else {
      return [];
    }
  }

  void setAccessToken(String token) {
    storage.write(AppConstants.sharedPreferenceKey.accessToken, token);
  }

  String getAccessToken() {
    final token =
        storage.read(AppConstants.sharedPreferenceKey.accessToken) ?? "";
    return token;
  }

  void setStoreId(int storeId) {
    storage.write(AppConstants.sharedPreferenceKey.storeId, storeId);
  }

  int getStoreId() {
    final storeId = storage.read(AppConstants.sharedPreferenceKey.storeId) ?? 0;
    return storeId;
  }

  void setStoreName(String storeName) {
    storage.write(AppConstants.sharedPreferenceKey.storeName, storeName);
  }

  String getStoreName() {
    final storeName =
        storage.read(AppConstants.sharedPreferenceKey.storeName) ?? "";
    return storeName;
  }

  void setQuantityNote(String note) {
    storage.write(AppConstants.sharedPreferenceKey.quantityNote, note);
  }

  String getQuantityNote() {
    final note =
        storage.read(AppConstants.sharedPreferenceKey.quantityNote) ?? "";
    return note;
  }

  void setStockData(ProductListResponse stockData) {
    storage.write(
        AppConstants.sharedPreferenceKey.stockList, jsonEncode(stockData));
  }

  ProductListResponse? getStockData() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.stockList) ?? "";
    if (!StringHelper.isEmptyString(stockData)) {
      final jsonMap = json.decode(stockData);
      return ProductListResponse.fromJson(jsonMap);
    } else {
      return null;
    }
  }

  void setStockFiltersData(StockFilterResponse stockData) {
    storage.write(AppConstants.sharedPreferenceKey.stockFilterData,
        jsonEncode(stockData));
  }

  StockFilterResponse? getStockFiltersData() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.stockFilterData) ?? "";
    if (!StringHelper.isEmptyString(stockData)) {
      final jsonMap = json.decode(stockData);
      return StockFilterResponse.fromJson(jsonMap);
    } else {
      return null;
    }
  }

  void setPermissions(PermissionResponse stockData) {
    storage.write(AppConstants.sharedPreferenceKey.permissionSettings,
        jsonEncode(stockData));
  }

  PermissionResponse getPermissions() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.permissionSettings) ?? "";
    PermissionResponse data = PermissionResponse();
    if (!StringHelper.isEmptyString(stockData)) {
      final jsonMap = json.decode(stockData);
      data = PermissionResponse.fromJson(jsonMap);
      return data;
    } else {
      return data;
    }
  }

  void setStockResources(StoreResourcesResponse stockData) {
    storage.write(
        AppConstants.sharedPreferenceKey.stockResources, jsonEncode(stockData));
  }

  StoreResourcesResponse? getStockResources() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.stockResources) ?? "";

    final jsonMap = json.decode(stockData);
    return StoreResourcesResponse.fromJson(jsonMap);
  }

  void setProductResources(ProductResourcesResponse data) {
    storage.write(
        AppConstants.sharedPreferenceKey.productResources, jsonEncode(data));
  }

  ProductResourcesResponse? getProductResources() {
    final data =
        storage.read(AppConstants.sharedPreferenceKey.productResources) ?? "";

    final jsonMap = json.decode(data);
    return ProductResourcesResponse.fromJson(jsonMap);
  }

  void setStoredStockList(List<StockStoreRequest> list) {
    storage.write(AppConstants.sharedPreferenceKey.localStoredStockList,
        jsonEncode(list));
  }

  List<StockStoreRequest> getStoredStockList() {
    final jsonString =
        storage.read(AppConstants.sharedPreferenceKey.localStoredStockList) ??
            "";
    if (!StringHelper.isEmptyString(jsonString)) {
      final jsonMap = json.decode(jsonString);
      List<StockStoreRequest> list = (jsonMap as List)
          .map((itemWord) => StockStoreRequest.fromJson(itemWord))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  // void setStoredProductList(List<ProductInfo> list) {
  //   storage.write(AppConstants.sharedPreferenceKey.localStoredProductList,
  //       jsonEncode(list));
  // }
  //
  // List<ProductInfo> getStoredProductList() {
  //   final jsonString =
  //       storage.read(AppConstants.sharedPreferenceKey.localStoredProductList) ??
  //           "";
  //   if (!StringHelper.isEmptyString(jsonString)) {
  //     final jsonMap = json.decode(jsonString);
  //     List<ProductInfo> list = (jsonMap as List)
  //         .map((itemWord) => ProductInfo.fromJson(itemWord))
  //         .toList();
  //     return list;
  //   } else {
  //     return [];
  //   }
  // }

  void setDashboardStockCountData(DashboardStockCountResponse data) {
    storage.write(AppConstants.sharedPreferenceKey.dashboardItemCountData,
        jsonEncode(data));
  }

  DashboardStockCountResponse? getDashboardStockCountData() {
    final data =
        storage.read(AppConstants.sharedPreferenceKey.dashboardItemCountData) ??
            "";

    final jsonMap = json.decode(data);
    return DashboardStockCountResponse.fromJson(jsonMap);
  }

  /*void setProductsData(ProductListResponse stockData) {
    storage.write(
        AppConstants.sharedPreferenceKey.productList, jsonEncode(stockData));
  }

  ProductListResponse? getProductsData() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.productList) ?? "";
    final jsonMap = json.decode(stockData);
    return ProductListResponse.fromJson(jsonMap);
  }*/

  void setStockSize(String size) {
    storage.write(AppConstants.sharedPreferenceKey.stockSize, size);
  }

  String getStockSize() {
    final size = storage.read(AppConstants.sharedPreferenceKey.stockSize) ?? "";
    return size;
  }

  void setTempId(int id) {
    storage.write(AppConstants.sharedPreferenceKey.tempIds, id);
  }

  int getTempId() {
    final id = storage.read(AppConstants.sharedPreferenceKey.tempIds) ?? 0;
    return id;
  }

  void setLastUpdateTime(String time) {
    storage.write(AppConstants.sharedPreferenceKey.lastUpdateTime, time);
  }

  String getLastUpdateTime() {
    final time =
        storage.read(AppConstants.sharedPreferenceKey.lastUpdateTime) ?? "";
    return time;
  }

  void setEditStockUserName(String name) {
    storage.write(AppConstants.sharedPreferenceKey.editStockUserName, name);
  }

  String getEditStockUserName() {
    final name =
        storage.read(AppConstants.sharedPreferenceKey.editStockUserName) ?? "";
    return name;
  }

  void setEditStockUserId(int id) {
    storage.write(AppConstants.sharedPreferenceKey.editStockUserId, id);
  }

  int getEditStockUserId() {
    final id =
        storage.read(AppConstants.sharedPreferenceKey.editStockUserId) ?? 0;
    return id;
  }

  void clearStoredStockList() {
    removeData(AppConstants.sharedPreferenceKey.localStoredStockList);
    if (getStockData() != null) {
      ProductListResponse response = getStockData()!;
      if (!StringHelper.isEmptyList(response.info!)) {
        for (int i = 0; i < response.info!.length; i++) {
          if (response.info![i].localStored ?? false) {
            response.info![i].localStored = false;
          }
        }
      }
      setStockData(response);
    }
  }

  // void clearAllData(){
  //   box.erase();
  // }

  void clearAllData() {
    AppConstants.isResourcesLoaded = false;
    removeData(AppConstants.sharedPreferenceKey.storeId);
    removeData(AppConstants.sharedPreferenceKey.storeName);
    removeData(AppConstants.sharedPreferenceKey.userInfo);
    removeData(AppConstants.sharedPreferenceKey.accessToken);
    removeData(AppConstants.sharedPreferenceKey.quantityNote);
    removeData(AppConstants.sharedPreferenceKey.stockList);
    removeData(AppConstants.sharedPreferenceKey.stockResources);
    removeData(AppConstants.sharedPreferenceKey.localStoredStockList);
    removeData(AppConstants.sharedPreferenceKey.dashboardItemCountData);
    removeData(AppConstants.sharedPreferenceKey.stockSize);
    removeData(AppConstants.sharedPreferenceKey.stockFilterData);
    removeData(AppConstants.sharedPreferenceKey.tempIds);
  }

  void removeData(String key) {
    storage.remove(key);
  }
}
