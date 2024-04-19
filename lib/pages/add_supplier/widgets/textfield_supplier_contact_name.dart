import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldSupplierContactName extends StatelessWidget {
  TextFieldSupplierContactName({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.contactNameController.value,
        hintText: 'contact_name'.tr,
        labelText: 'contact_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
