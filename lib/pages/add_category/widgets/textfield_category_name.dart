import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldCategoryName extends StatelessWidget {
  TextFieldCategoryName({super.key});

  final addCategoryController = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 20),
      child: TextFieldBorder(
        textEditingController: addCategoryController.categoryNameController.value,
        hintText: 'category_name'.tr,
        labelText: 'category_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          addCategoryController.onValueChange();
        },
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
