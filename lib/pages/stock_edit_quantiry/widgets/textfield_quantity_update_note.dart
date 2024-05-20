import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldQuantityUpdateNote extends StatelessWidget {
  TextFieldQuantityUpdateNote({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return TextFieldBorder(
      textEditingController: stockEditQuantityController.noteController.value,
      hintText: 'reference'.tr,
      labelText: 'reference'.tr,
      textInputAction: TextInputAction.newline,
      validator: MultiValidator([]),
      textAlignVertical: TextAlignVertical.top,
    );
  }
}
