import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_screen.dart';
import 'package:otm_inventory/pages/add_store/view/add_store_screen.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_screen.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_screen.dart';
import 'package:otm_inventory/pages/login/login_screen.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_screen.dart';
import 'package:otm_inventory/pages/qr_code_scanner/view/qr_code_scanner.dart';
import 'package:otm_inventory/pages/splash/splash_screen.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_screen.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_screen.dart';
import 'package:otm_inventory/pages/store_list/view/store_list_screen.dart';
import 'package:otm_inventory/pages/supplier_list/view/supplier_list_screen.dart';

import '../pages/category_list/category_list_screen.dart';
import '../pages/products/add_product/view/add_product_screen.dart';
import '../pages/products/product_list/view/product_list_screen.dart';
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
    GetPage(
      name: AppRoutes.storeListScreen,
      page: () => StoreListScreen(),
    ),
    GetPage(
      name: AppRoutes.supplierListScreen,
      page: () => SupplierListScreen(),
    ),
    GetPage(
      name: AppRoutes.qrCodeScannerScreen,
      page: () => QrCodeScanner(),
    ),
    GetPage(
      name: AppRoutes.addStoreScreen,
      page: () => AddStoreScreen(),
    ),
    GetPage(
      name: AppRoutes.addSupplierScreen,
      page: () => AddSupplierScreen(),
    ),
    GetPage(
      name: AppRoutes.categoryListScreen,
      page: () => CategoryListScreen(),
    ),
    GetPage(
      name: AppRoutes.addCategoryScreen,
      page: () => AddCategoryScreen(),
    ),
    GetPage(
      name: AppRoutes.stockListScreen,
      page: () => StockListScreen(),
    ),
    GetPage(
      name: AppRoutes.stockEditQuantityScreen,
      page: () => StockEditQuantityScreen(),
    ),
  ];
}
