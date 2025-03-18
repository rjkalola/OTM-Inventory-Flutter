import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';


class OrderListEmptyView extends StatelessWidget {
  OrderListEmptyView({super.key});

  final controller = Get.put(OrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style: const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
