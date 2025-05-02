import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_details_total_item_count_price_view.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_info_view.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_product_item_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar_notification.dart';
import 'package:otm_inventory/widgets/custom_divider.dart';

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
          appBar: _buildAppBar(),
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
                            height: 4,
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

  PreferredSizeWidget _buildAppBar() {
    if (controller.fromNotification.value) {
      return BaseAppbarNotification(
          appBar: AppBar(),
          title: "",
          isCenterTitle: false,
          isBack: true);
    } else {
      return BaseAppBar(
          appBar: AppBar(),
          title: "",
          isCenterTitle: false,
          isBack: true);
    }
  }
}
