import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../../utils/app_storage.dart';

class SplashServices {
  void isLogin() {
    Timer(const Duration(seconds: 1), () {
      ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
      Get.offAllNamed(AppRoutes.addProductScreen);
   /*   if(ApiConstants.accessToken.isNotEmpty){
        Get.offAllNamed(AppRoutes.dashboardScreen);
      }else{
        Get.offAllNamed(AppRoutes.loginScreen);
      }*/
      // Get.toNamed(AppRoutes.LOGIN_SCREEN);
    });
  }
}
