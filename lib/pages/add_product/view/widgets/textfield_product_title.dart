import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';
class TextFieldProductTitle extends StatelessWidget {
   TextFieldProductTitle({super.key});
  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      child: TextFieldBorder(
          textEditingController: addProductController.productTitleController.value,
          hintText: 'product_title'.tr,
          labelText: 'product_title'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
          ]),
      ),
    );
  }
}
