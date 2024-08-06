import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/pages/barcode_list/controller/barcode_list_controller.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

import '../../../../res/colors.dart';
import '../../../../widgets/PrimaryBorderButton.dart';

class SaveBarcodeButton extends StatelessWidget {
  SaveBarcodeButton({super.key});

  final controller = Get.put(BarcodeListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
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
                onPressed: () {
                  controller.onSubmitClick();
                },
              )),
        ],
      ),
    );
  }
}
