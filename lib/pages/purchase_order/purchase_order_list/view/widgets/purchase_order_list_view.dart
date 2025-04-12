import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
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
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return InkWell(
                  onTap: () {
                    controller.viewOrderDetails(controller.orderList[position]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: PrimaryTextView(
                                  text:
                                      controller.orderList[position].orderId ??
                                          "",
                                  color: primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            Expanded(
                                flex: 4,
                                child: PrimaryTextView(
                                  text: controller
                                          .orderList[position].supplierName ??
                                      "",
                                  textAlign: TextAlign.center,
                                  color: primaryTextColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                            Expanded(
                                flex: 3,
                                child: PrimaryTextView(
                                  softWrap: true,
                                  textAlign: TextAlign.end,
                                  text: controller
                                          .orderList[position].statusText ??
                                      "",
                                  color: AppUtils.getPurchaseOrderStatusColor(
                                      controller.orderList[position].status ??
                                          0),
                                  fontSize: 17,
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
                          fontSize: 15,
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.orderList.length,
              separatorBuilder: (context, position) => const Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  height: 0,
                  color: dividerColor,
                  thickness: 0.8,
                ),
              ),
            ),
          ),
        ));
  }
}
