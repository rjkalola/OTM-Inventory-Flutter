import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/barcode_list/controller/barcode_list_controller.dart';

import '../../../../res/colors.dart';

class BarcodeListEmptyView extends StatelessWidget {
  BarcodeListEmptyView({super.key});

  final barcodeListController = Get.put(BarcodeListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: barcodeListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style: const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
