import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';

class TextFieldSupplierPhoneNumber extends StatelessWidget {
  TextFieldSupplierPhoneNumber({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController:
              addSupplierController.phoneNumberController.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          onValueChange: (value) {
            addSupplierController.onValueChange();
          },
          textInputAction: TextInputAction.next,
          validator: MultiValidator([
            // RequiredValidator(errorText: 'required_field'.tr),
          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ]),
    );
  }
}
