import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';
import '../add_supplier_controller.dart';

class TextFieldSupplierPhoneExtension extends StatelessWidget {
  TextFieldSupplierPhoneExtension({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 7, 18),
      child: TextFieldPhoneExtensionWidget(
          mExtension: addSupplierController.mExtension.value,
          mFlag: addSupplierController.mFlag.value,
          onPressed: () {
            addSupplierController.showPhoneExtensionDialog();
          }),
    ));
  }
}
