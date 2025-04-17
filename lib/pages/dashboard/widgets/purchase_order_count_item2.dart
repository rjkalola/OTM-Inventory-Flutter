import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otm_inventory/utils/app_utils.dart';

import '../../../res/colors.dart';
import '../../../widgets/text/PrimaryTextView.dart';

class PurchaseOrderCountItem2 extends StatelessWidget {
  PurchaseOrderCountItem2(
      {super.key,
      required this.count,
      required this.title,
      required this.flex});

  int count;
  String title;
  int flex;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.fromLTRB(3, 9, 3, 9),
        decoration: AppUtils.getGrayBorderDecoration(
            color: Color(AppUtils.haxColor("#f7f5f6")), radius: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryTextView(
              text: count.toString(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryTextColor,
            ),
            const SizedBox(
              width: 6,
            ),
            Flexible(
              child: PrimaryTextView(
                softWrap: true,
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: primaryTextColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
