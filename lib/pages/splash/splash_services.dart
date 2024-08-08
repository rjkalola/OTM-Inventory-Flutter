import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_storage.dart';

class SplashServices {
  void isLogin() {
    AppStorage().removeData(AppConstants.sharedPreferenceKey.quantityNote);
    Timer(const Duration(seconds: 1), () async {
      ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
      // Get.offAllNamed(AppRoutes.stockEditQuantityScreen);

      // List<UserInfo> list = Get.find<AppStorage>().getLoginUsers();
      // print("array length:"+list.length.toString());
      // AppStorage.uniqueId = await AppUtils.getDeviceUniqueId();
      // print("AppStorage.uniqueId:" + AppStorage.uniqueId);
      if (ApiConstants.accessToken.isNotEmpty) {
        if (AppStorage.storeId != 0) {
          Get.offAllNamed(AppRoutes.stockListScreen);
        } else {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        }
      } else {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }
}
