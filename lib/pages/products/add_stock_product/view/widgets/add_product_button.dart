import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

import '../../controller/add_stock_product_controller.dart';

class AddStockProductButton extends StatelessWidget {
  AddStockProductButton({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'save'.tr,
      onPressed: () {
        // if (addProductController.isSaveEnable.value) {
        addProductController.onSubmitClick();
        // }
      },
    );
  }
}
