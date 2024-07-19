import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/string_helper.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../controller/purchase_order_details_controller.dart';

class OrderDate extends StatelessWidget {
  OrderDate({super.key});

  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(controller.info?.ref)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: PrimaryTextView(
              text: "Order Date: ${controller.info!.date}",
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              softWrap: true,
            ),
          )
        : Container();
  }
}
