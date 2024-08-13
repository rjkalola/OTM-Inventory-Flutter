import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../controller/add_store_controller.dart';

class TextFieldStoreTown extends StatelessWidget {
  TextFieldStoreTown({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addStoreController.townController.value,
        hintText: 'town'.tr,
        labelText: 'town'.tr,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
        onValueChange: (value) {
          addStoreController.onValueChange();
        },
      ),
    );
  }
}
