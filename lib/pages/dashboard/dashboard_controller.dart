import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/home_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/profile/profile_tab.dart';
import 'package:otm_inventory/routes/app_routes.dart';

import '../../utils/app_constants.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final selectedIndex = 0.obs;
  final pageController = PageController();
  final tabs = <Widget>[
    HomeTab(),
    ProfileTab(),
    MoreTab(),
  ];

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void onItemTapped(int index) {
    // if (index == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ScannerScreen()),
    //   );
    // } else {
    pageController.jumpToPage(index);
    // }
  }

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
        Get.toNamed(AppRoutes.productListScreen);
    } else if (action == AppConstants.action.store) {
      Get.toNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.toNamed(AppRoutes.supplierListScreen);
    }else if (action == AppConstants.action.categories) {
      Get.toNamed(AppRoutes.categoryListScreen);
    }
  }
}
