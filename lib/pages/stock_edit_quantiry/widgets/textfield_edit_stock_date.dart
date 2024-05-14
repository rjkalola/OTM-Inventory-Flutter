import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../stock_edit_quantity_controller.dart';

class TextFieldEditStockDate extends StatelessWidget {
  TextFieldEditStockDate({super.key});
  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
      child: TextFieldBorder(
          textEditingController: stockEditQuantityController.dateController.value,
          hintText: 'date'.tr,
          labelText: 'date'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([

          ]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          onPressed: () {
            stockEditQuantityController.showDatePickerDialog();
          }
      ),
    );
  }
}
