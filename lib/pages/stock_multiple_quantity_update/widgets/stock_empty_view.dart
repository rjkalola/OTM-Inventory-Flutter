import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_controller.dart';

import '../../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';

class StockMultipleQuantityUpdateEmptyView extends StatelessWidget {
  StockMultipleQuantityUpdateEmptyView({super.key});

  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('empty_data_message'.tr,
                    style: const TextStyle(
                        fontSize: 16, color: secondaryTextColor)),
               const SizedBox(height: 12,),
                PrimaryBorderButton(
                  buttonText: 'reload'.tr,
                  textColor: defaultAccentColor,
                  borderColor: defaultAccentColor,
                  height: 30,
                  fontSize: 14,
                  onPressed: () {
                    stockListController.getStockListApi(true);
                  },
                )
              ],
            ),
          )),
        ));
  }
}
