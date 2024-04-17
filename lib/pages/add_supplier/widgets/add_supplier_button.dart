import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

import '../add_supplier_controller.dart';

class AddSupplierButton extends StatelessWidget {
  AddSupplierButton({super.key});

  final addSupplierController = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'save'.tr,
      onPressed: () {
        addSupplierController.onSubmitClick();
      },
    );
  }
}
