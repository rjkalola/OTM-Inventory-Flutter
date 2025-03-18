import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class OrderDateRangeView extends StatelessWidget {
  OrderDateRangeView({super.key});

  final controller = Get.put(OrderListController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.isMainViewVisible.value,
      child: Container(
        padding: EdgeInsets.all(12),
        color: titleBgColor,
        width: double.infinity,
        child: Center(
          child: PrimaryTextView(
            text: "${controller.fromDate.value} to ${controller.toDate.value}",
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
