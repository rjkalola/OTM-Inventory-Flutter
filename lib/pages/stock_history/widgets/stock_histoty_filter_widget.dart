import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../stock_quantity_history_controller.dart';

class StockHistoryFilterWidget extends StatelessWidget {
  StockHistoryFilterWidget({super.key});

  final stockQuantityHistoryController =
      Get.put(StockQuantityHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(45))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            tabButton(
                'All',
                getTextColor(AppConstants.stockFilterType.filterAll),
                getBgColor(AppConstants.stockFilterType.filterAll), () {
              stockQuantityHistoryController.filterData(AppConstants.stockFilterType.filterAll);
            }),
            tabButton('In', getTextColor(AppConstants.stockFilterType.filterIn),
                getBgColor(AppConstants.stockFilterType.filterIn), () {
                  stockQuantityHistoryController.filterData(AppConstants.stockFilterType.filterIn);
                }),
            tabButton(
                'Out',
                getTextColor(AppConstants.stockFilterType.filterOut),
                getBgColor(AppConstants.stockFilterType.filterOut), () {
              stockQuantityHistoryController.filterData(AppConstants.stockFilterType.filterOut);
            })
          ],
        ),
      ),
    ));
  }

  Widget tabButton(String text, Color textColor, Color backgroundColor,
      VoidCallback onPressed) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45), // <-- Radius
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Color getTextColor(String tab) {
    return stockQuantityHistoryController.filterTab.value == tab
        ? Colors.white
        : defaultAccentColor;
  }

  Color getBgColor(String tab) {
    return stockQuantityHistoryController.filterTab.value == tab
        ? defaultAccentColor
        : Colors.white;
  }

}
