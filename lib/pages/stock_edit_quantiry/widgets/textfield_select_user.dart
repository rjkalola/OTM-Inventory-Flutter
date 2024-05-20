import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../stock_edit_quantity_controller.dart';

class TextFieldSelectUser extends StatelessWidget {
  TextFieldSelectUser({super.key});
  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return  TextFieldBorder(
        textEditingController: stockEditQuantityController.userController.value,
        hintText: 'select_user'.tr,
        labelText: 'select_user'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([

        ]),
        isReadOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        onPressed: () {
          stockEditQuantityController.showUsersList();
        }
    );
  }
}
