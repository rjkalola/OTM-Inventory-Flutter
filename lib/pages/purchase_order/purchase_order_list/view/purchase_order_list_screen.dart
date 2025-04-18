import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_controller.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/view/widgets/purchase_order_list_empty_view.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/view/widgets/purchase_order_list_view.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/view/widgets/search_purchase_order_widget.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../common/widgets/common_bottom_navigation_bar_widget.dart';
import '../../../dashboard/widgets/main_drawer.dart';

class PurchaseOrderListScreen extends StatefulWidget {
  const PurchaseOrderListScreen({super.key});

  @override
  State<PurchaseOrderListScreen> createState() =>
      _PurchaseOrderListScreenState();
}

class _PurchaseOrderListScreenState extends State<PurchaseOrderListScreen> {
  final controller = Get.put(PurchaseOrderListController());
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => Container(
      color: backgroundColor,
      child: SafeArea(
              child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'purchase_order'.tr,
                isCenterTitle: false,
                isBack: true,
                widgets: actionButtons()),
            drawer: MainDrawer(),
            floatingActionButton: (controller.totalPendingCount.value == 0)
                ? FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.green,
                    tooltip: '',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    onPressed: () {
                      AppUtils.showSnackBarMessage('data_is_up_to_date'.tr);
                    },
                    child: const Icon(Icons.check, color: Colors.white, size: 25),
                  )
                : SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      backgroundColor: defaultAccentColor,
                      onPressed: () {
                        controller.onCLickSyncData(true);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      label: Text(
                        controller.totalPendingCount.value.toString(),
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      icon: const Icon(Icons.autorenew_outlined,
                          color: Colors.white, size: 24),
                    ),
                  ),
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
                const SearchPurchaseOrderWidget(),
                controller.orderList.isNotEmpty
                    ? PurchaseOrderListView()
                    : PurchaseOrderListEmptyView(),
                const SizedBox(
                  height: 12,
                ),
              ]),
            ),
          )),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: storeListController.productList.isNotEmpty,
      //   child: IconButton(
      //     icon: SvgPicture.asset(
      //       width: 22,
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
      //     storeListController.stockFilter();
      //   },
      // ),
      // Visibility(
      //   visible: AppUtils.isPermission(AppStorage().getPermissions().addStore),
      //   child: IconButton(
      //     icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
      //     onPressed: () {
      //       storeListController.addStoreClick(null);
      //     },
      //   ),
      // ),
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
