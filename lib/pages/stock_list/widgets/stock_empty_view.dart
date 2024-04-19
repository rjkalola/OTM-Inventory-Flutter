import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/colors.dart';
import '../stock_list_controller.dart';

class StockListEmptyView extends StatelessWidget {
  StockListEmptyView({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style: const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
