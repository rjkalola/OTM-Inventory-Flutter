import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldQuantity extends StatelessWidget {
  TextFieldQuantity({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFieldBorder(
        textEditingController:
            stockEditQuantityController.quantityController.value,
        hintText: 'quantity'.tr,
        labelText: 'quantity'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        onValueChange: (value) {
          if (value.contains(",") || value.contains(".")) {
            String newText = value.replaceAll(",", "").replaceAll(".", "");
            stockEditQuantityController.quantityController.value.text = newText;
          }
          String text =
              stockEditQuantityController.quantityController.value.text;
          if (text.length > 1 && value.endsWith("-")) {
            String newText = text.substring(0, text.length - 1);
            stockEditQuantityController.quantityController.value.text = newText;
          }
          stockEditQuantityController.onQuantityUpdate(value.toString().trim());
        },
      ),
    );
  }
}
