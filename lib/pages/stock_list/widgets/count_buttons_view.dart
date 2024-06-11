import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';

class CountButtonsView extends StatelessWidget {
  const CountButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryBorderButton(
                buttonText: 'sync'.tr,
                textColor: defaultAccentColor,
                borderColor: defaultAccentColor,
                onPressed: () {},
              ),
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: Container(
            color: bottomTabBackgroundColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                  child: Text(
                'app_up_to_Date'.tr,
                style: const TextStyle(
                    color: defaultAccentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            ),
          ),
        )
      ],
    );
  }
}
