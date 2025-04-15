import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';

class StoreNameDropdown extends StatelessWidget {
  StoreNameDropdown({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !StringHelper.isEmptyString(
              dashboardController.storeNameController.value.text)
          ? GestureDetector(
              onTap: () {
                dashboardController
                    .selectStore(AppConstants.dialogIdentifier.changeStore);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                margin: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                decoration: AppUtils.getGrayBorderDecoration(
                    borderColor: Colors.grey.shade300,
                    borderWidth: 1,
                    radius: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryTextView(
                        text:
                            dashboardController.storeNameController.value.text,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    )
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
