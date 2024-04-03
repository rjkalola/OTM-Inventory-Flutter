import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/login_screen.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_screen.dart';
import 'package:otm_inventory/pages/splash/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.SPLASH_SCREEN,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN_SCREEN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.VERIFY_OTP_SCREEN,
      page: () => VerifyOtpScreen(),
    ),
  ];
}
