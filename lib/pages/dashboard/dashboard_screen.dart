import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/main_drawer.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import '../../res/drawable.dart';
import '../../widgets/appbar/base_appbar.dart';
import '../stock_list/stock_list_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Scaffold(
              backgroundColor: backgroundColor,
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: dashboardController.title.value,
                isBack: true,
                widgets: actionButtons(),
              ),
              drawer: MainDrawer(),
              body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PageView(
                  controller: dashboardController.pageController,
                  onPageChanged: dashboardController.onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: dashboardController.tabs,
                ),
              ),
              bottomNavigationBar: BottomNavigationBarWidget(),
            )));
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: productListController.productList.isNotEmpty,
      //   child: IconButton(
      //     icon: SvgPicture.asset(
      //       width: 22,with exception
      //       Drawable.searchIcon,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // IconButton(
      //   icon: SvgPicture.asset(
      //     width: 22,
      //     Drawable.filterIcon,
      //   ),
      //   onPressed: () {
      //     dashboardController.stockFilter();
      //   },
      // ),
      Visibility(
        visible: (dashboardController.selectedIndex.value == 0 &&
            !Get.put(StockListController()).isScanQrCode.value),
        child: InkWell(
            onTap: () {
              dashboardController.addMultipleStockQuantity();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                "+${'add_stock'.tr}",
                style: const TextStyle(
                    fontSize: 16,
                    color: defaultAccentColor,
                    fontWeight: FontWeight.w500),
              ),
            )),
      ),
      Visibility(
        visible: (dashboardController.selectedIndex.value == 0 &&
            Get.put(StockListController()).isScanQrCode.value),
        child: InkWell(
            onTap: () {
              Get.put(StockListController())
                  .getStockListApi(true, false, "", true, true);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                'clear'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
            )),
      ),
    ];
  }
}
