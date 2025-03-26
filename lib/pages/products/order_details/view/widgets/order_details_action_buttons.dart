import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';

class OrderDetailsActionButtons extends StatelessWidget {
  OrderDetailsActionButtons(
      {super.key, required this.status, required this.productId});

  final controller = Get.put(OrderDetailsController());
  final int status;
  final int productId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        status == AppConstants.orderStatus.PLACED
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 16, 0),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryBorderButton(
                        buttonText: 'reject'.tr,
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        onPressed: () {
                          controller.showStatusUpdateDialog(productId,
                              AppConstants.orderStatus.REJECTED, 'reject'.tr.toLowerCase());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: PrimaryBorderButton(
                          buttonText: 'accept'.tr,
                          textColor: defaultAccentColor,
                          borderColor: defaultAccentColor,
                          onPressed: () {
                            controller.showStatusUpdateDialog(productId,
                                AppConstants.orderStatus.ACCEPTED, 'accept'.tr.toLowerCase());
                          },
                        )),
                  ],
                ),
              )
            : Container(),
        status == AppConstants.orderStatus.ACCEPTED
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 16, 0),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: PrimaryBorderButton(
                        buttonText: 'cancel'.tr,
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        onPressed: () {
                          controller.showStatusUpdateDialog(productId,
                              AppConstants.orderStatus.CANCELLED, 'cancel'.tr.toLowerCase());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: PrimaryBorderButton(
                          buttonText: 'ready_to_deliver'.tr,
                          textColor: defaultAccentColor,
                          borderColor: defaultAccentColor,
                          onPressed: () {
                            controller.showStatusUpdateDialog(
                                productId,
                                AppConstants.orderStatus.READY_TO_DELIVERED,
                                'ready_to_deliver'.tr.toLowerCase());
                          },
                        )),
                  ],
                ),
              )
            : Container(),
        status == AppConstants.orderStatus.READY_TO_DELIVERED
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 16, 0),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryBorderButton(
                        buttonText: 'cancel'.tr,
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        onPressed: () {
                          controller.showStatusUpdateDialog(productId,
                              AppConstants.orderStatus.CANCELLED, 'cancel'.tr.toLowerCase());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: PrimaryBorderButton(
                          buttonText: 'deliver'.tr,
                          textColor: defaultAccentColor,
                          borderColor: defaultAccentColor,
                          onPressed: () {
                            controller.showStatusUpdateDialog(
                                productId,
                                AppConstants.orderStatus.DELIVERED,
                                'deliver'.tr);
                          },
                        )),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
