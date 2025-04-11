import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_controller.dart';
import 'package:otm_inventory/res/colors.dart';

class FeedListEmptyView extends StatelessWidget {
  FeedListEmptyView({super.key});

  final controller = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Text('empty_data_message'.tr,
                style:
                    const TextStyle(fontSize: 16, color: secondaryTextColor)),
          )),
        ));
  }
}
