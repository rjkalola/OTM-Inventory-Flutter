import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';

class TextFieldSupplierWeight extends StatelessWidget {
  TextFieldSupplierWeight({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 6, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.weightController.value,
        hintText: 'weight'.tr,
        labelText: 'weight'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        validator: MultiValidator([]),
      ),
    );
  }
}
