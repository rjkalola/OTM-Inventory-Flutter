import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';
import '../stock_multiple_quantity_update_controller.dart';

class StockQtyStoreButtons extends StatelessWidget {
  StockQtyStoreButtons({super.key});

  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    return stockListController.productList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: PrimaryBorderButton(
                    buttonText: 'save'.tr,
                    textColor: defaultAccentColor,
                    borderColor: defaultAccentColor,
                    onPressed: () {
                      stockListController.onClickAddQuantityButton();
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: PrimaryBorderButton(
                    buttonText: 'cancel'.tr,
                    textColor: Colors.red,
                    borderColor: Colors.red,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
