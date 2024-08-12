import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../controller/add_stock_product_controller.dart';

class TextFieldStockProductUuid extends StatelessWidget {
  TextFieldStockProductUuid({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController:
              addProductController.productUuidController.value,
          hintText: 'id_'.tr,
          labelText: 'id_'.tr,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onValueChange: (value) {
            addProductController.onValueChange();
          },
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
          ]),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            LengthLimitingTextInputFormatter(10),
          ]),
    );
  }
}
