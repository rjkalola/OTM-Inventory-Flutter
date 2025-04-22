import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class SelectIconTitle extends StatelessWidget {
  const SelectIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: PrimaryTextView(
        text: 'select_icon'.tr,
        fontSize: 16,
        color: primaryTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
