import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../controller/add_store_controller.dart';

class TextFieldStorePostCode extends StatelessWidget {
  TextFieldStorePostCode({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addStoreController.postcodeController.value,
        hintText: 'postcode'.tr,
        labelText: 'postcode'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        validator: MultiValidator([]),
      ),
    );
  }
}
