import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';

class TextFieldSupplierTown extends StatelessWidget {
  TextFieldSupplierTown({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.townController.value,
        hintText: 'town'.tr,
        labelText: 'town'.tr,
        onValueChange: (value) {
          addSupplierController.onValueChange();
        },
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
