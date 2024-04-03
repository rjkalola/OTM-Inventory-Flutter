import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class SplashServices {
  void isLogin() {
    Timer(Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.LOGIN_SCREEN);
    });
  }
}
