import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
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
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ]
      ),
    );
  }
}
