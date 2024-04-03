import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class SplashServices {
  void isLogin() {
    Timer(const Duration(seconds: 1), () {
      // Get.offAllNamed(AppRoutes.VERIFY_OTP_SCREEN);
      Get.toNamed(AppRoutes.VERIFY_OTP_SCREEN);
    });
  }
}
