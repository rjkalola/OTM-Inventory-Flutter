import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStoreStreet extends StatelessWidget {
  TextFieldStoreStreet({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addStoreController.streetController.value,
        hintText: 'street'.tr,
        labelText: 'street'.tr,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
