import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/controller/purchase_order_details_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldNote extends StatelessWidget {
  TextFieldNote({super.key});

  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: TextFieldBorder(
        textEditingController: controller.noteController.value,
        hintText: 'note'.tr,
        labelText: 'note'.tr,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
        onValueChange: (value) {},
      ),
    );
  }
}
