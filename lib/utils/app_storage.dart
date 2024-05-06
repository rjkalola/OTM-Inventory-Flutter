import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/otp_verification/model/user_info.dart';

class AppStorage extends GetxController {
  final box = GetStorage();
  static int storeId = 0;
  static String storeName = "";

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void setUserInfo(UserInfo info) {
    box.write(AppConstants.sharedPreferenceKey.userInfo, info.toJson());
  }

  UserInfo getUserInfo() {
    final map = box.read(AppConstants.sharedPreferenceKey.userInfo) ?? {};
    return UserInfo.fromJson(map);
  }

  void setLoginUsers(List<UserInfo> list) {
    box.write(AppConstants.sharedPreferenceKey.savedLoginUserList, jsonEncode(list));
  }

  List<UserInfo> getLoginUsers() {
    final jsonString = box.read(AppConstants.sharedPreferenceKey.savedLoginUserList) ?? "";
    if(!StringHelper.isEmptyString(jsonString)){
      final jsonMap = json.decode(jsonString);
      List<UserInfo> list = (jsonMap as List)
          .map((itemWord) => UserInfo.fromJson(itemWord))
          .toList();
      // List<UserInfo> list = (jsonDecode(jsonString) as List<dynamic>).cast<UserInfo>();
      return list;
    }else {
      return [];
    }
  }

  void setAccessToken(String token) {
    box.write(AppConstants.sharedPreferenceKey.accessToken, token);
  }

  String getAccessToken() {
    final token = box.read(AppConstants.sharedPreferenceKey.accessToken) ?? "";
    return token;
  }

  void setStoreId(int storeId) {
    box.write(AppConstants.sharedPreferenceKey.storeId, storeId);
  }

  int getStoreId() {
    final storeId = box.read(AppConstants.sharedPreferenceKey.storeId) ?? 0;
    return storeId;
  }

  void setStoreName(String storeName) {
    box.write(AppConstants.sharedPreferenceKey.storeName, storeName);
  }

  String getStoreName() {
    final storeName = box.read(AppConstants.sharedPreferenceKey.storeName) ?? "";
    return storeName;
  }

  // void clearAllData(){
  //   box.erase();
  // }

  void clearAllData(){
    removeData(AppConstants.sharedPreferenceKey.storeId);
    removeData(AppConstants.sharedPreferenceKey.storeName);
    removeData(AppConstants.sharedPreferenceKey.userInfo);
    removeData(AppConstants.sharedPreferenceKey.accessToken);
  }

  void removeData(String key){
    box.remove(key);
  }



}
