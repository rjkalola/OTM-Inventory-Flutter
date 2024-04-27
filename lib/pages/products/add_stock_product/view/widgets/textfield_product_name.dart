import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_stock_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStockProductName extends StatelessWidget {
  TextFieldStockProductName({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      child: TextFieldBorder(
        textEditingController: addProductController.productNameController.value,
        hintText: 'product_name'.tr,
        labelText: 'product_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
