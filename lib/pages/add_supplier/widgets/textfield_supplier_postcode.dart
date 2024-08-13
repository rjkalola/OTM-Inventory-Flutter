
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';

class TextFieldSupplierPostCode extends StatelessWidget {
  TextFieldSupplierPostCode({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.postcodeController.value,
        hintText: 'postcode'.tr,
        labelText: 'postcode'.tr,
        keyboardType: TextInputType.name,
        onValueChange: (value) {
          addSupplierController.onValueChange();
        },
        textInputAction: TextInputAction.done,
        validator: MultiValidator([]),
      ),
    );
  }
}
