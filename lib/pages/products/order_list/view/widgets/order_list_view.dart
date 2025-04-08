import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../../res/colors.dart';

class OrderListView extends StatelessWidget {
  OrderListView({super.key});

  final controller = Get.put(OrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: controller.scrollController,
              children: List.generate(
                controller.itemList.length,
                (position) => InkWell(
                  onTap: () {
                    controller.orderDetailsClick(controller.itemList[position]);
                  },
                  child: CardView(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryTextView(
                              text:
                                  "Order Id: ${controller.itemList[position].orderId ?? ""}",
                              color: secondaryLightTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            PrimaryTextView(
                              text: controller
                                      .itemList[position].formattedCreatedAt ??
                                  "",
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
                                    controller.itemList[position]
                                            .orderedUserImage ??
                                        "",
                                    36,
                                    36,
                                    45),
                                const SizedBox(
                                  width: 6,
                                ),
                                PrimaryTextView(
                                  text: controller
                                          .itemList[position].orderedUserName ??
                                      "",
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
                                      "QTY: ${(controller.itemList[position].totalQty ?? 0).toString()}",
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
                          text: controller.itemList[position].orderStatus ?? "",
                          color: AppUtils.getStatusTextColor(
                              controller.itemList[position].orderStatusInt ??
                                  0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  )),
                ),
              ),
            ),
          ),
        ));
  }
}
