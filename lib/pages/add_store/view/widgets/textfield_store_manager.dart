import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStoreManager extends StatelessWidget {
  TextFieldStoreManager({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController:
              addStoreController.storeManagerController.value,
          hintText: 'store_manager'.tr,
          labelText: 'store_manager'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
          ]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            addStoreController.showStoreManagerList();
          }),
    );
  }
}
