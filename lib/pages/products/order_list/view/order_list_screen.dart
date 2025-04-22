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
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

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
      onPopInvokedWithResult: (didPop, result) async {
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
        child: Obx(
          () => SafeArea(
              child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
                appBar: AppBar(),
                widgets: actionButtons(),
                title: 'orders'.tr,
                isCenterTitle: false,
                isBack: true),
            drawerScrimColor: Colors.transparent,
            drawer: MainDrawer(),
            bottomNavigationBar: const CommonBottomNavigationBarWidget(),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Column(children: [
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                // OrderDateRangeView(),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                Visibility(visible: true, child: const SearchOrderWidget()),
                Visibility(
                  visible: controller.isOrderCheckVisible.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      PrimaryTextView(
                        text: controller.isCheckAll.value
                            ? 'unselect_all'.tr
                            : 'select_all'.tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        softWrap: true,
                      ),
                      Checkbox(
                          activeColor: defaultAccentColor,
                          value: controller.isCheckAll.value,
                          onChanged: (isCheck) {
                            controller.isCheckAll.value = isCheck!;
                            if (isCheck) {
                              controller.checkAllItems();
                            } else {
                              controller.unCheckAllItems();
                            }
                          })
                    ],
                  ),
                ),
                controller.itemList.isNotEmpty
                    ? OrderListView()
                    : OrderListEmptyView(),
                const SizedBox(
                  height: 12,
                ),
              ]),
            ),
          )),
        ),
      ),
    );
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
      Visibility(
        visible: controller.isOrderCheckVisible.value,
        child: InkWell(
            onTap: () {
              controller.isOrderCheckVisible.value = false;
              controller.unCheckAllItems();
              controller.isCheckAll.value = false;
            },
            child: Text(
              'cancel'.tr,
              style: const TextStyle(
                  fontSize: 16, color: Colors.red, fontWeight: FontWeight.w400),
            )),
      ),
      Visibility(
          visible: controller.isOrderCheckVisible.value,
          child: const SizedBox(
            width: 10,
          )),
      Visibility(
        visible: controller.isOrderCheckVisible.value,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
              onTap: () async {
                if (!StringHelper.isEmptyString(
                    controller.getCommaSeparateIds())) {
                  controller.showChangeOrderStatusDialog();
                }
              },
              child: Text(
                'change_status'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    color: defaultAccentColor,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
      Visibility(
        visible: !controller.isOrderCheckVisible.value,
        child: Padding(
          padding: const EdgeInsets.only(right: 18),
          child: InkWell(
              onTap: () {
                controller.isOrderCheckVisible.value = true;
              },
              child: Text(
                'select'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    color: defaultAccentColor,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
    ];
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
