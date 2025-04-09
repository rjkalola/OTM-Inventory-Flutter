import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../widgets/text/PrimaryTextView.dart';

class DashboardStockCountItem extends StatelessWidget {
  DashboardStockCountItem(
      {super.key,
      this.title,
      this.value,
      this.valueColor,
      required this.onPressed});

  final dashboardController = Get.put(DashboardController());

  String? title, value;
  Color? valueColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: CardView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          PrimaryTextView(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryTextColor,
          ),
          PrimaryTextView(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: valueColor,
          )
        ]),
      )),

      /* child: Container(
        margin: const EdgeInsets.fromLTRB(16, 7, 16, 7),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: dashboardController.getBorderDecoration(
            borderColor: Colors.transparent,
            borderWidth: 0,
            color: Color(AppUtils.haxColor("#f7f5f6")),
            radius: 10),
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(AppUtils.haxColor("#d5d9dc"))),
            child: Icon(
              Icons.warning_rounded,
              size: 30,
              weight: 300,
              color: Color(AppUtils.haxColor("#fffffe")),
            ),
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
            children: [
              PrimaryTextView(
                text: value,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor,
              )
            ],
          )
        ]),
      ),*/
    );
  }
}
