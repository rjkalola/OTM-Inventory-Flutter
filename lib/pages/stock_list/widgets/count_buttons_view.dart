import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';
import '../stock_list_controller.dart';

class CountButtonsView extends StatelessWidget {
  CountButtonsView({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: stockListController.isPendingDataCount.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryBorderButton(
                buttonText:
                    stockListController.pendingDataCountButtonTitle.value,
                textColor: defaultAccentColor,
                borderColor: defaultAccentColor,
                onPressed: () {
                  stockListController.onCLickUploadData(
                      true,
                      stockListController.localStockCount(),
                      stockListController.localProductCount());
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: stockListController.isUpToDateData.value,
          child: Container(
            color: bottomTabBackgroundColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                  child: Text(
                'app_up_to_Date'.tr,
                style: const TextStyle(
                    color: defaultAccentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            ),
          ),
        )
      ],
    );
  }
}
