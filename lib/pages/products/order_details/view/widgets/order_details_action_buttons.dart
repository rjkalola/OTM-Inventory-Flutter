import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';

class OrderDetailsActionButtons extends StatelessWidget {
  OrderDetailsActionButtons({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryBorderButton(
              buttonText: 'cancel'.tr,
              textColor: Colors.red,
              borderColor: Colors.red,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryBorderButton(
                buttonText: 'accept'.tr,
                textColor: defaultAccentColor,
                borderColor: defaultAccentColor,
                onPressed: () {
                  // controller.receiveOrder();
                },
              )),
        ],
      ),
    );
  }
}
