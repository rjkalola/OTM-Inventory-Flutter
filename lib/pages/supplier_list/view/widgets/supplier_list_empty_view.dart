import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/pages/supplier_list/controller/supplier_list_controller.dart';

import '../../../../res/colors.dart';

class SupplierListEmptyView extends StatelessWidget {
  SupplierListEmptyView({super.key});

  final supplierListController = Get.put(SupplierListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: supplierListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style: const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
