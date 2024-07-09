import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/barcode_scan_switch_view.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/header_view.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/order_date.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/product_item.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/reference.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/supplier_name.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/textfield_note.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_divider.dart';

import '../../../../res/colors.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../common/widgets/common_bottom_navigation_bar_widget.dart';
import '../controller/purchase_order_details_controller.dart';

class PurchaseOrderDetailsScreen extends StatefulWidget {
  const PurchaseOrderDetailsScreen({super.key});

  @override
  State<PurchaseOrderDetailsScreen> createState() =>
      _PurchaseOrderDetailsScreenState();
}

class _PurchaseOrderDetailsScreenState
    extends State<PurchaseOrderDetailsScreen> {
  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'purchase_order'.tr,
          isBack: true,
          widgets: actionButtons()),
      // drawer: MainDrawer(),
      bottomNavigationBar: const CommonBottomNavigationBarWidget(),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomDivider(thickness: 1, height: 1),
            HeaderView(),
            SupplierName(),
            Reference(),
            OrderDate(),
            CustomDivider(thickness: 9, height: 9),
            BarcodeScanSwitchView(),
            ProductItem(
              onValueChange: (value) {},
              controller: controller.searchController,
            ),
            SizedBox(
              height: 9,
            ),
            CustomDivider(thickness: 9, height: 9),
            TextFieldNote()
          ]),
        ),
      ),
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
}
