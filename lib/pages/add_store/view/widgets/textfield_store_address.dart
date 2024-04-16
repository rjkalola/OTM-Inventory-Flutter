import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStoreAddress extends StatelessWidget {
  TextFieldStoreAddress({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
      child: TextFieldBorder(
        textEditingController: addStoreController.addressController.value,
        hintText: 'address'.tr,
        labelText: 'address'.tr,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
