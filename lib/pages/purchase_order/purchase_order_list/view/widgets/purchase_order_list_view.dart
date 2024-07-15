import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class PurchaseOrderListView extends StatelessWidget {
  PurchaseOrderListView({super.key});

  final controller = Get.put(PurchaseOrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                controller.orderList.length,
                (position) => InkWell(
                  onTap: () {
                    controller.viewOrderDetails(controller.orderList[position]);
                  },
                  child: CardView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: PrimaryTextView(
                                    text: controller
                                            .orderList[position].orderId ??
                                        "",
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: PrimaryTextView(
                                    text: "Ravi Kalola Ravi Kalola",
                                    textAlign: TextAlign.center,
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: PrimaryTextView(
                                    textAlign: TextAlign.end,
                                    text:
                                        controller.orderList[position].status ??
                                            "",
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          PrimaryTextView(
                            text: controller.orderList[position].date ?? "",
                            color: secondaryLightTextColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
