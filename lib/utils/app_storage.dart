import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/add_store/model/store_resources_response.dart';
import '../pages/otp_verification/model/user_info.dart';
import '../pages/products/product_list/models/product_list_response.dart';
import '../pages/stock_edit_quantiry/model/store_stock_request.dart';

class AppStorage extends GetxController {
  final storage = GetStorage();
  static int storeId = 0;
  static String storeName = "";

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
    final jsonMap = json.decode(stockData);
    return ProductListResponse.fromJson(jsonMap);
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

  void setStoredStockList(List<StockStoreRequest> list) {
    storage.write(
        AppConstants.sharedPreferenceKey.localStoredStockList, jsonEncode(list));
  }

  List<StockStoreRequest> getStoredStockList() {
    final jsonString =
        storage.read(AppConstants.sharedPreferenceKey.localStoredStockList) ?? "";
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

  void clearStoredStockList(){
    removeData(AppConstants.sharedPreferenceKey.localStoredStockList);
  }

  // void clearAllData(){
  //   box.erase();
  // }

  void clearAllData() {
    removeData(AppConstants.sharedPreferenceKey.storeId);
    removeData(AppConstants.sharedPreferenceKey.storeName);
    removeData(AppConstants.sharedPreferenceKey.userInfo);
    removeData(AppConstants.sharedPreferenceKey.accessToken);
    removeData(AppConstants.sharedPreferenceKey.quantityNote);
    removeData(AppConstants.sharedPreferenceKey.stockList);
    removeData(AppConstants.sharedPreferenceKey.stockResources);
    removeData(AppConstants.sharedPreferenceKey.localStoredStockList);
  }

  void removeData(String key) {
    storage.remove(key);
  }
}
