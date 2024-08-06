import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';
import '../../controller/barcode_list_controller.dart';

class ActionButtons extends StatelessWidget {
  ActionButtons({super.key});

  final controller = Get.put(BarcodeListController());

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
                buttonText: 'save'.tr,
                textColor: defaultAccentColor,
                borderColor: defaultAccentColor,
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
