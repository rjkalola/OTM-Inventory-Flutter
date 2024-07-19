import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../controller/purchase_order_details_controller.dart';

class HeaderView extends StatelessWidget {
  HeaderView({super.key});

  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryTextView(
            text: controller.info?.orderId ?? "",
            color: primaryTextColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          PrimaryTextView(
            text: controller.info?.statusText ?? "",
            color: AppUtils.getPurchaseOrderStatusColor(
                controller.info?.status ??
                    0),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
