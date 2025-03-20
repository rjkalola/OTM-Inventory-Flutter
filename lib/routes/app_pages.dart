import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_screen.dart';
import 'package:otm_inventory/pages/add_store/view/add_store_screen.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_screen.dart';
import 'package:otm_inventory/pages/barcode_list/view/barcode_list_screen.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_screen.dart';
import 'package:otm_inventory/pages/login/login_screen.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_screen.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/add_stock_product_screen.dart';
import 'package:otm_inventory/pages/products/import_products/view/import_products_screen.dart';
import 'package:otm_inventory/pages/products/order_details/view/order_details_screen.dart';
import 'package:otm_inventory/pages/products/order_list/view/order_list_screen.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/view/purchase_order_list_screen.dart';
import 'package:otm_inventory/pages/qr_code_scanner/view/qr_code_scanner.dart';
import 'package:otm_inventory/pages/splash/splash_screen.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_screen.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_screen.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_screen.dart';
import 'package:otm_inventory/pages/store_list/view/store_list_screen.dart';
import 'package:otm_inventory/pages/supplier_list/view/supplier_list_screen.dart';

import '../pages/category_list/category_list_screen.dart';
import '../pages/product_pdf/view/view_pdf_screen.dart';
import '../pages/products/add_product/view/add_product_screen.dart';
import '../pages/products/product_list/view/product_list_screen.dart';
import '../pages/purchase_order/purchase_order_details/view/purchase_order_details_screen.dart';
import '../pages/stock_filter/view/stock_filter_screen.dart';
import '../pages/stock_history/stock_quantity_history_screen.dart';
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
    GetPage(
      name: AppRoutes.stockQuantityHistoryScreen,
      page: () => StockQuantityHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.addStockProductScreen,
      page: () => AddStockProductScreen(),
    ),
    GetPage(
      name: AppRoutes.stockMultipleQuantityUpdateScreen,
      page: () => StockMultipleQuantityUpdateScreen(),
    ),
    GetPage(
      name: AppRoutes.stockFilterScreen,
      page: () => StockFilterScreen(),
    ),
    GetPage(
      name: AppRoutes.viewPdfScreen,
      page: () => ViewPdfScreen(),
    ),
    GetPage(
      name: AppRoutes.purchaseOrderListScreen,
      page: () => PurchaseOrderListScreen(),
    ),
    GetPage(
      name: AppRoutes.purchaseOrderDetailsScreen,
      page: () => PurchaseOrderDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.barcodeListScreen,
      page: () => BarcodeListScreen(),
    ),
    GetPage(
      name: AppRoutes.importProductsScreen,
      page: () => ImportProductsScreen(),
    ),
    GetPage(
      name: AppRoutes.orderListScreen,
      page: () => OrderListScreen(),
    ),
    GetPage(
      name: AppRoutes.orderDetailsScreen,
      page: () => OrderDetailsScreen(),
    ),
  ];
}
