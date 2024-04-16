import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';

import '../../controller/add_store_controller.dart';

class TextFieldStorePhoneExtension extends StatelessWidget {
  TextFieldStorePhoneExtension({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 7, 20),
      child: TextFieldPhoneExtensionWidget(
          mExtension: addStoreController.mExtension.value,
          mFlag: addStoreController.mFlag.value,
          onPressed: () {
            addStoreController.showPhoneExtensionDialog();
          }),
    ));
  }
}
