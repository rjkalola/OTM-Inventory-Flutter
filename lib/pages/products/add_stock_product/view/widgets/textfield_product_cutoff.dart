import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../controller/add_stock_product_controller.dart';

class TextFieldStockProductCutoff extends StatelessWidget {
  TextFieldStockProductCutoff({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
        textEditingController:
            addProductController.productCutoffController.value,
        hintText: 'cutoff'.tr,
        labelText: 'cutoff'.tr,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        textInputAction: TextInputAction.next,
        validator: MultiValidator([]),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
