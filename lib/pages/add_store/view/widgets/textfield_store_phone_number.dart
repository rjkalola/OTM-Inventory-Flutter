import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class TextFieldPhoneNumber extends StatelessWidget {
  TextFieldPhoneNumber({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 14, 20),
      child: TextFieldBorder(
          textEditingController: addStoreController.phoneNumberController.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onValueChange: (value) {
            addStoreController.onValueChange();
          },
          validator: MultiValidator([
            // RequiredValidator(errorText: 'required_field'.tr),
          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ]),
    );
  }
}
