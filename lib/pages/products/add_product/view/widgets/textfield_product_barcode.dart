import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldProductBarCode extends StatelessWidget {
  TextFieldProductBarCode({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: addProductController.isDeleteVisible.value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
        child: TextFieldBorder(
          textEditingController: addProductController.productBarcodeController.value,
          hintText: 'barcode_list'.tr,
          labelText: 'barcode_list'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([]),
        ),
      ),
    );
  }
}
