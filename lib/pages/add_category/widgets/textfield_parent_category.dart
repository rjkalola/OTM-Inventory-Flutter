import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldParentCategory extends StatelessWidget {
  TextFieldParentCategory({super.key});

  final addCategoryController = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
      child: TextFieldBorder(
          textEditingController:
              addCategoryController.parentCategoryController.value,
          hintText: 'parent_category'.tr,
          labelText: 'parent_category'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            addCategoryController.showParentCategoryList();
          }),
    );
  }
}
