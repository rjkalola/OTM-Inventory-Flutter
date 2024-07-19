import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';

class PurchaseOrderListEmptyView extends StatelessWidget {
  PurchaseOrderListEmptyView({super.key});

  final controller = Get.put(PurchaseOrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('empty_data_message'.tr,
                    style: const TextStyle(
                        fontSize: 16, color: secondaryTextColor)),
                const SizedBox(
                  height: 12,
                ),
                Visibility(
                  visible: StringHelper.isEmptyString(
                      controller.searchController.value.text),
                  child: PrimaryBorderButton(
                    buttonText: 'sync'.tr,
                    textColor: defaultAccentColor,
                    borderColor: defaultAccentColor,
                    height: 30,
                    fontSize: 14,
                    onPressed: () async {
                      bool isInternet = await AppUtils.interNetCheck();
                      if (isInternet) {
                        controller.getPurchaseOrderListApi(true);
                      } else {
                        AppUtils.showSnackBarMessage('no_internet'.tr);
                      }
                    },
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
