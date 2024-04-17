import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../add_supplier_controller.dart';
class TextFieldSupplierWeightUnit extends StatelessWidget {
  TextFieldSupplierWeightUnit({super.key});
  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController: addSupplierController.weightUnitController.value,
          hintText: 'weight_unit'.tr,
          labelText: 'weight_unit'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([

          ]),
          onPressed: () {
            addSupplierController.showWeightList();
          }
      ),
    );
  }
}
