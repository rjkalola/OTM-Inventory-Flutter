import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';
class TextFieldProductSupplier extends StatelessWidget {
  TextFieldProductSupplier({super.key});
  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController: addProductController.productSupplierController.value,
          hintText: 'supplier'.tr,
          labelText: 'supplier'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([

          ]),
          onPressed: () {
            addProductController.showSupplierList();
          }
      ),
    );
  }
}
