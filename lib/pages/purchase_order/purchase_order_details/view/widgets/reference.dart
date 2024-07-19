import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../controller/purchase_order_details_controller.dart';

class Reference extends StatelessWidget {
  Reference({super.key});

  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(controller.info?.ref)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: PrimaryTextView(
              text: "Ref: ${controller.info!.ref}",
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              softWrap: true,
            ),
          )
        : Container();
  }
}
