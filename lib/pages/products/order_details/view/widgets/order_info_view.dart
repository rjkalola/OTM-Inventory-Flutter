import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class OrderInfoView extends StatelessWidget {
  OrderInfoView({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextView(
                  text: "Order Id: ${controller.orderInfo.value.orderId ?? ""}",
                  color: secondaryLightTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                PrimaryTextView(
                  text: controller.orderInfo.value.formattedCreatedAt ?? "",
                  color: secondaryLightTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageUtils.setUserImage(
                        controller.orderInfo.value.orderedUserImage ?? "",
                        36,
                        36,
                        45),
                    const SizedBox(
                      width: 6,
                    ),
                    PrimaryTextView(
                      text: controller.orderInfo.value.orderedUserName ?? "",
                      color: primaryTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      color: defaultAccentColor,
                      Icons.location_on_outlined,
                      weight: 300,
                      size: 26,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    PrimaryTextView(
                      text:
                          "QTY: ${(controller.orderInfo.value.totalQty ?? 0).toString()}",
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            PrimaryTextView(
              text: controller.orderInfo.value.orderStatus ?? "",
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
