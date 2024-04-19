import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldProductWeight extends StatelessWidget {
  TextFieldProductWeight({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 6, 18),
      child: TextFieldBorder(
        textEditingController: addProductController.productWeightController.value,
        hintText: 'weight'.tr,
        labelText: 'weight'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([]),
      ),
    );
  }
}
