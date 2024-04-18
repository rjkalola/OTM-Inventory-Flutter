import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_controller.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

class AddCategoryButton extends StatelessWidget {
  AddCategoryButton({super.key});

  final addCategoryController = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'save'.tr,
      onPressed: () {
        addCategoryController.onSubmitClick();
      },
    );
  }
}
