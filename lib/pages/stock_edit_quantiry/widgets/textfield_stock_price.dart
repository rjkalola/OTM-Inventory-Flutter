import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStockPrice extends StatelessWidget {
  TextFieldStockPrice({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: TextFieldBorder(
          textEditingController: stockEditQuantityController.priceController.value,
          hintText: "${'price'.tr} (£)",
          labelText: "${'price'.tr} (£)",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: MultiValidator([

          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          onPressed: () {
            // stockEditQuantityController.showUsersList();
          }
      ),
    );
  }
}
