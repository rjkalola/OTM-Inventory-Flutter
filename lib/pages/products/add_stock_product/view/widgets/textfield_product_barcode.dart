import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../controller/add_stock_product_controller.dart';

class TextFieldStockProductBarCode extends StatelessWidget {
  TextFieldStockProductBarCode({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: TextFieldBorder(
          textEditingController:
              addProductController.productBarcodeController.value,
          hintText: 'barcode_list'.tr,
          labelText: 'barcode_list'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([]),
          isReadOnly: true,
          onValueChange: (value) {
            addProductController.onValueChange();
          },
          onPressed: () {
            addProductController.moveToBarCodeListScreen();
          },
        ),
      ),
    );
  }
}
