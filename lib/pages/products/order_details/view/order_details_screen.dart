import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/widgets/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/main_drawer.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_repository.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_details_action_buttons.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_details_textfield_select_users.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_details_total_item_count_price_view.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_info_view.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_product_item_list.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/textfield_note_order_details.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/date_range_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/order_list_empty_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/order_list_view.dart';
import 'package:otm_inventory/pages/products/order_list/view/widgets/search_order_widget.dart';
import 'package:otm_inventory/pages/supplier_list/view/widgets/supplier_list_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_divider.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final controller = Get.put(OrderDetailsController());
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.back(result: controller.isUpdated.value);
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
              appBar: AppBar(), title: "", isCenterTitle: false, isBack: true),
          // drawer: MainDrawer(),
          // bottomNavigationBar: const CommonBottomNavigationBarWidget(),
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Column(
                children: [
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: dividerColor,
                  ),
                  Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          OrderInfoView(),
                          CustomDivider(thickness: 9, height: 9),
                          const SizedBox(
                            height: 9,
                          ),
                          OrderProductItemsList(),
                          const SizedBox(
                            height: 9,
                          ),
                          CustomDivider(thickness: 9, height: 9),
                          const SizedBox(
                            height: 12,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Column(
                      children: [
                        // OrderDetailsTextFieldSelectUser(),
                        // TextFieldNoteOrderDetails(),
                        OrderDetailsTotalItemCountPriceView(),
                        // OrderDetailsActionButtons()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
