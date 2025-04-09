import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../widgets/text/PrimaryTextView.dart';

class DashboardStockCountItem2 extends StatelessWidget {
  DashboardStockCountItem2(
      {super.key,
      this.title,
      this.itemCount,
      this.totalAmount,
      this.iconPath,
      this.iconColor,
      required this.bgColor,
      required this.borderColor,
      required this.circleColor,
      required this.isFullSizeIcon,
      this.iconPadding,
      required this.onPressed});

  final dashboardController = Get.put(DashboardController());

  String? title, itemCount, totalAmount, iconPath;
  Color? iconColor, borderColor, bgColor, circleColor;
  bool isFullSizeIcon;
  double? iconPadding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 7, 16, 7),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: dashboardController.getBorderDecoration(
            borderColor: borderColor,
            borderWidth: 1.5,
            color: bgColor,
            radius: 16),
        child: Row(children: [
          !isFullSizeIcon
              ? Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: EdgeInsets.all(iconPadding ?? 9),
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: circleColor),
                  child: ImageUtils.setAssetsImage(
                      path: iconPath ?? "",
                      width: 30,
                      height: 30,
                      color: iconColor,
                      fit: BoxFit.fill),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ImageUtils.setAssetsImage(
                      path: iconPath ?? "",
                      width: 50,
                      height: 50,
                      color: iconColor,
                      fit: BoxFit.fill),
                ),
          Expanded(
            child: PrimaryTextView(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PrimaryTextView(
                text: itemCount ?? "",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
              PrimaryTextView(
                text: totalAmount ?? "",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: secondaryLightTextColor,
              )
            ],
          )
        ]),
      ),
    );
  }
}
