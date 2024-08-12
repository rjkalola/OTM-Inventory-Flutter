import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../controller/add_stock_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStockProductTitle extends StatelessWidget {
  TextFieldStockProductTitle({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController:
            addProductController.productTitleController.value,
        hintText: 'product_short_name'.tr,
        labelText: 'product_short_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([]),
        onValueChange: (value) {
          addProductController.onValueChange();
        },
      ),
    );
  }
}
