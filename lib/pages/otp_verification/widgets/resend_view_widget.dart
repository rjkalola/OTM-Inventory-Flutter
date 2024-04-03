import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../verify_otp_controller.dart';

class ResendViewWidget extends StatelessWidget {
  ResendViewWidget({super.key});

  final verifyOtpController = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: RichText(
          text: TextSpan(
        text: 'click_on_'.tr,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: 'resend_'.tr,
              recognizer: TapGestureRecognizer()..onTap = () {},
              style: const TextStyle(
                  fontSize: 16,
                  color: defaultAccentColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(text: 'otm_received_note'.tr),
        ],
      )),
    );
  }
}
