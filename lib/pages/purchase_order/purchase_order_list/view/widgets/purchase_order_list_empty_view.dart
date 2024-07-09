import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_controller.dart';

import '../../../../../res/colors.dart';

class PurchaseOrderListEmptyView extends StatelessWidget {
  PurchaseOrderListEmptyView({super.key});

  final controller = Get.put(PurchaseOrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style:
                    const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
