import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/home_tab.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final selectedIndex = 0.obs;
  final pageController = PageController();
  final tabs = <Widget>[
    HomeTab(),
    HomeTab(),
    HomeTab(),
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
}
