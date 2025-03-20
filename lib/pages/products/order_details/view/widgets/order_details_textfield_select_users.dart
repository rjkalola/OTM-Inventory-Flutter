import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class OrderDetailsTextFieldSelectUser extends StatelessWidget {
  OrderDetailsTextFieldSelectUser({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 7),
      child: TextFieldBorder(
          textEditingController: controller.userController.value,
          hintText: 'select_user'.tr,
          labelText: 'select_user'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            // controller.showUsersList();
          }),
    );
  }
}
