import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../widgets/PrimaryBorderButton.dart';
import '../stock_list_controller.dart';

class UploadStockButtonWidget extends StatelessWidget {
  UploadStockButtonWidget({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: stockListController.isMainViewVisible.value &&
          stockListController.isUpdateStockButtonVisible.value,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: PrimaryBorderButton(
              buttonText: 'update_stock'.tr,
              textColor: defaultAccentColor,
              borderColor: defaultAccentColor,
              onPressed: () {
                // stockListController.onClickUploadStockButton();
              },
            )),
      ),
    );
  }
}
