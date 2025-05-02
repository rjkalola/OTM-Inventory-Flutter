import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_stock_quantity.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class BottomButtonQtyView extends StatelessWidget {
  BottomButtonQtyView({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: PrimaryBorderButton(
              buttonText: 'deduct'.tr,
              textColor: Colors.red,
              borderColor: Colors.red,
              onPressed: () {
                stockEditQuantityController.onUpdateQuantityClick(true);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    child: TextFieldQuantity(),
                  ),
                  stockEditQuantityController.isPackOffEnable.value &&
                          !stockEditQuantityController
                              .isPackOffQuantityAddEnable.value
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: PrimaryTextView(
                              text: stockEditQuantityController
                                      .productInfo.value.pack_off_unit_name ??
                                  "",
                              color: defaultAccentColor,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
          Visibility(
            visible: !(stockEditQuantityController.isPackOffEnable.value &&
                !stockEditQuantityController.isPackOffQuantityAddEnable.value),
            child: const SizedBox(
              width: 12,
            ),
          ),
          Visibility(
            visible: !(stockEditQuantityController.isPackOffEnable.value &&
                !stockEditQuantityController.isPackOffQuantityAddEnable.value),
            child: Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: PrimaryBorderButton(
                buttonText: 'add'.tr,
                textColor: Colors.green,
                borderColor: Colors.green,
                onPressed: () {
                  stockEditQuantityController.onUpdateQuantityClick(false);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
