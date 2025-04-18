import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/controller/add_store_controller.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

import '../../../../../widgets/PrimaryBorderButton.dart';

class UploadButton extends StatelessWidget {
  UploadButton({super.key});

  final controller = Get.put(ImportProductsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isFileDetailsVisible.value
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryBorderButton(
                  buttonText: 'upload'.tr,
                  textColor: defaultAccentColor,
                  borderColor: defaultAccentColor,
                  onPressed: () {
                    // Get.back();
                    if (!controller.isLoading.value) {
                      controller.onCLickImportProduct();
                    }
                  },
                ),
              ),
            )
          : Container(),
    );
  }
}
