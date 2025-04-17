import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/purchase_order_count_item2.dart';

class PurchaseOrderView extends StatelessWidget {
  PurchaseOrderView({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PurchaseOrderCountItem2(
                count: dashboardController.mIssuedCount.value,
                title: 'issued'.tr,
                flex: 7,
              ),
              const SizedBox(
                width: 8,
              ),
              PurchaseOrderCountItem2(
                count: dashboardController.mPartiallyReceivedCount.value,
                title: 'partially_received'.tr,
                flex: 13,
              ),
              const SizedBox(
                width: 8,
              ),
              PurchaseOrderCountItem2(
                count: dashboardController.mCancelledCount.value,
                title: 'cancelled'.tr,
                flex: 9,
              )
            ],
          ),
        ),
      ),
    );
  }
}
