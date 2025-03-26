import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldNoteOrderDetails extends StatelessWidget {
  TextFieldNoteOrderDetails({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 7),
      child: TextFieldBorder(
        textEditingController: controller.noteController.value,
        hintText: 'note'.tr,
        labelText: 'note'.tr,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
        onValueChange: (value) {
          // stockEditQuantityController.isClearReferenceVisible.value =
          //     !StringHelper.isEmptyString(value.toString());
        },
      ),
    );
  }
}
