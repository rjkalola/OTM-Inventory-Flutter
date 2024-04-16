import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/controller/add_product_controller.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldStoreName extends StatelessWidget {
  TextFieldStoreName({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      child: TextFieldBorder(
        textEditingController: addStoreController.storeNameController.value,
        hintText: 'store_name'.tr,
        labelText: 'store_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
