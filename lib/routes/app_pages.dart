import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/view/add_product_screen.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_screen.dart';
import 'package:otm_inventory/pages/login/login_screen.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_screen.dart';
import 'package:otm_inventory/pages/product_list/view/product_list_screen.dart';
import 'package:otm_inventory/pages/splash/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.verifyOtpScreen,
      page: () => VerifyOtpScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboardScreen,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.productListScreen,
      page: () => ProductListScreen(),
    ),
    GetPage(
      name: AppRoutes.addProductScreen,
      page: () => AddProductScreen(),
    ),
  ];
}
