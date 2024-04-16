import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

class AddStoreButton extends StatelessWidget {
  AddStoreButton({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'save'.tr,
      onPressed: () {
        addStoreController.onSubmitClick();
      },
    );
  }
}
