import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldSupplierEmail extends StatelessWidget {
  TextFieldSupplierEmail({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController: addSupplierController.emailController.value,
        hintText: 'email'.tr,
        labelText: 'email'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
          EmailValidator(errorText: 'email_valid_error'.tr)
        ]),
      ),
    );
  }
}
