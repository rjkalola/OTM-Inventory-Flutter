import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';


class SaveStockQuantityButton extends StatelessWidget {
  SaveStockQuantityButton({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          buttonText: 'save'.tr,
          onPressed: () {
            stockEditQuantityController.onUpdateQuantityClick();
          },
        ),
      ),
    );
  }
}
