import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../res/drawable.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';

class BarcodeScanSwitchView extends StatelessWidget {
  const BarcodeScanSwitchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    width: 26,
                    height: 26,
                    Drawable.barCodeIcon,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              PrimaryTextView(
                text: 'scan_items'.tr,
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
          Switch(value: false, onChanged: (value) {})
        ],
      ),
    );
  }
}
