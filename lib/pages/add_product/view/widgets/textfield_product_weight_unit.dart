import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';
class TextFieldProductWeightUnit extends StatelessWidget {
  TextFieldProductWeightUnit({super.key});
  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController: addProductController.productWeightUnitController.value,
          hintText: 'weight_unit'.tr,
          labelText: 'weight_unit'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([

          ]),
          onPressed: () {
            addProductController.showWeightList();
          }
      ),
    );
  }
}
