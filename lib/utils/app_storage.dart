import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../pages/otp_verification/model/user_info.dart';

class AppStorage extends GetxController {
  final box = GetStorage();
  static int storeId = 0;

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

  void clearAllData(){
    box.erase();
  }

  void removeData(String key){
    box.remove(key);
  }



}