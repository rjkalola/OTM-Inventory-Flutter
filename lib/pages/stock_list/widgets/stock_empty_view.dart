import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';
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
                    stockListController.getStockListApi(true, false, "",true,true);
                  },
                )
              ],
            ),
          )),
        ));
  }
}
