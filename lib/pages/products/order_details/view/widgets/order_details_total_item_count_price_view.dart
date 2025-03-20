import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';

class OrderDetailsTotalItemCountPriceView extends StatelessWidget {
  OrderDetailsTotalItemCountPriceView({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryTextView(
              text: "${controller.orderProductList.length} Items",
              color: primaryTextColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              softWrap: true,
            ),
            PrimaryTextView(
              text:
                  "${controller.orderInfo.value.currency ?? ""}${controller.orderInfo.value.totalPrice ?? ""}",
              color: primaryTextColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
