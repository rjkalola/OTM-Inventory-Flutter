import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/widgets/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/main_drawer.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/date_range_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/order_list_empty_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/order_list_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/search_order_widget.dart';
import 'package:otm_inventory/pages/supplier_list/view/widgets/supplier_list_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final controller = Get.put(OrderListController());
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'orders'.tr,
              isCenterTitle: false,
              isBack: true),
          drawer: MainDrawer(),
          bottomNavigationBar: const CommonBottomNavigationBarWidget(),
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Column(children: [
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                OrderDateRangeView(),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                Visibility(
                    visible: controller.itemList.isNotEmpty,
                    child: const SearchOrderWidget()),
                controller.itemList.isNotEmpty
                    ? OrderListView()
                    : OrderListEmptyView(),
                const SizedBox(
                  height: 12,
                ),
              ]),
            ),
          ),
        )),
      ),
    );
  }

  Future<bool> onBackPress() {
    DateTime now = DateTime.now();
    if (mTime == null || now.difference(mTime) > const Duration(seconds: 2)) {
      mTime = now;
      AppUtils.showSnackBarMessage('exit_warning'.tr);
      return Future.value(false);
    }

    return Future.value(true);
  }
}
