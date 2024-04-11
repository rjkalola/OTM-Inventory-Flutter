import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';

import '../../../../res/colors.dart';

class StoreListEmptyView extends StatelessWidget {
  StoreListEmptyView({super.key});

  final storeListController = Get.put(StoreListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: storeListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style: const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
