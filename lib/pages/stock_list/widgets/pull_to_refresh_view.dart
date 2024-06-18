import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../widgets/text/PrimaryTextView.dart';
import '../stock_list_controller.dart';

class PullToRefreshView extends StatelessWidget {
  PullToRefreshView({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
      visible: stockListController.pullToRefreshVisible.value,
      child: Container(
        width: double.infinity,
        color: titleBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              const Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.keyboard_double_arrow_down_outlined,
                        size: 30,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    PrimaryTextView(
                      text: 'pull_down_to_refresh'.tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                    PrimaryTextView(
                      text:
                      "Last Updated: ${stockListController.pullToRefreshTime.value}",
                      fontSize: 15,
                      color: secondaryTextColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
