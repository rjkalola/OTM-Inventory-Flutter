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
                10,
                (position) => InkWell(
                  onTap: () {
                    // if (AppUtils.isPermission(
                    //     AppStorage().getPermissions().updateStore)) {
                    //   storeListController.addStoreClick(
                    //       storeListController.storeList[position]);
                    // }
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
                                    text: "PO-232323",
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
                                    text: "Issued",
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          PrimaryTextView(
                            text: "07/05/24",
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
