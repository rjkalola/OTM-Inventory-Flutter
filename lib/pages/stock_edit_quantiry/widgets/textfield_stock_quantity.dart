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
        labelText: "",
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        autofocus: true,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          // FilteringTextInputFormatter.allow(RegExp(r'^[\d\-+]+$')),
        ],
        onValueChange: (value) {
          if (value.contains(",") || value.contains(".")) {
            String newText = value.replaceAll(",", "").replaceAll(".", "");
            stockEditQuantityController.quantityController.value.text = newText;
          }

          String text =
              stockEditQuantityController.quantityController.value.text;
          if (stockEditQuantityController.isAddQtyVisible.value) {
            if (text.length > 1 && value.endsWith("-")) {
              String newText = text.substring(0, text.length - 1);
              text = newText;
              stockEditQuantityController.quantityController.value.text =
                  newText;
            }
            if(!text.startsWith("+")){
              String newText = "+$text";
              print("new text:"+newText);
              stockEditQuantityController.quantityController.value.text =
                  newText;
            }
          } else {
              if(!text.startsWith("-")){
                String newText = "-$text";
                print("new text:"+newText);
                stockEditQuantityController.quantityController.value.text =
                    newText;
              }
          }

          stockEditQuantityController.onQuantityUpdate(value.toString().trim());
        },
      ),
    );
  }
}
