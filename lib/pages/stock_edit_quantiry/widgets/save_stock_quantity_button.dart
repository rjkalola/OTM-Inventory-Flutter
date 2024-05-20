import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';

import '../../../widgets/PrimaryBorderButton.dart';

class SaveStockQuantityButton extends StatelessWidget {
  SaveStockQuantityButton({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      // child: Row(
      //   children: [
      //     Flexible(
      //       fit: FlexFit.tight,
      //       flex: 1,
      //       child: PrimaryBorderButton(
      //         buttonText: 'deduct'.tr,
      //         textColor: Colors.red,
      //         borderColor: Colors.red,
      //         onPressed: () {
      //           stockEditQuantityController.onUpdateQuantityClick(true);
      //         },
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 12,
      //     ),
      //     Flexible(
      //       fit: FlexFit.tight,
      //       flex: 1,
      //       child: PrimaryBorderButton(
      //         buttonText: 'add'.tr,
      //         textColor: Colors.green,
      //         borderColor: Colors.green,
      //         onPressed: () {
      //           stockEditQuantityController.onUpdateQuantityClick(false);
      //         },
      //       ),
      //     )
      //   ],
      // ),
      child: Stack(
        children: [
          Visibility(
            visible: stockEditQuantityController.isDeductQtyVisible.value,
            child: PrimaryBorderButton(
              buttonText: 'deduct'.tr,
              textColor: Colors.red,
              borderColor: Colors.red,
              onPressed: () {
                stockEditQuantityController.onUpdateQuantityClick(true);
              },
            ),
          ),
          Visibility(
            visible: stockEditQuantityController.isAddQtyVisible.value,
            child: PrimaryBorderButton(
              buttonText: 'add'.tr,
              textColor: Colors.green,
              borderColor: Colors.green,
              onPressed: () {
                stockEditQuantityController.onUpdateQuantityClick(false);
              },
            ),
          )
        ],
      ),
    ));
  }
}
