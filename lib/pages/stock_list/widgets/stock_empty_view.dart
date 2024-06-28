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
                // const SizedBox(
                //   height: 16,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 18, right: 18),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: PrimaryBorderButton(
                //       buttonText: stockListController.downloadTitle.value,
                //       textColor: Colors.green,
                //       borderColor: Colors.green,
                //       fontSize: 14,
                //       onPressed: () {
                //         stockListController.getAllStockListApi(true,true);
                //       },
                //     ),
                //   ),
                // )
              ],
            ),
          )),
        ));
  }
}
