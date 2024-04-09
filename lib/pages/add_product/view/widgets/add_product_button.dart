import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

import '../../controller/add_product_controller.dart';

class AddProductButton extends StatelessWidget {
  AddProductButton({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'submit'.tr,
      onPressed: () {
        addProductController.onSubmitClick();
      },
    );
  }
}
