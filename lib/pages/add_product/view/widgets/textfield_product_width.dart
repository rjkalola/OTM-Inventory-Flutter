import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldProductWidth extends StatelessWidget {
  TextFieldProductWidth({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 18),
      child: TextFieldBorder(
        textEditingController: addProductController.productWidthController.value,
        hintText: 'width'.tr,
        labelText: 'width'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([]),
      ),
    );
  }
}
