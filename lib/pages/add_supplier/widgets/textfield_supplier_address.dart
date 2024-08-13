import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';

class TextFieldSupplierAddress extends StatelessWidget {
  TextFieldSupplierAddress({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.addressController.value,
        hintText: 'location'.tr,
        labelText: 'location'.tr,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        onValueChange: (value) {
          addSupplierController.onValueChange();
        },
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
