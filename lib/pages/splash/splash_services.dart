import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';

import '../../utils/app_storage.dart';

class SplashServices {
  void isLogin() {
    Timer(const Duration(seconds: 3), () {
      String accessToken = Get.find<AppStorage>().getAccessToken();
      if(accessToken.isNotEmpty){
        Get.offAllNamed(AppRoutes.DASHBOARD_SCREEN);
      }else{
        Get.offAllNamed(AppRoutes.LOGIN_SCREEN);
      }
      // Get.toNamed(AppRoutes.LOGIN_SCREEN);
    });
  }
}
