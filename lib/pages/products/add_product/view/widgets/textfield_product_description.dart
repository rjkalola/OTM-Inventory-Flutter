import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldProductDescription extends StatelessWidget {
  TextFieldProductDescription({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addProductController.productDescriptionController.value,
        hintText: 'description'.tr,
        labelText: 'description'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
