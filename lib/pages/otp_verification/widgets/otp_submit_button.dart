import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../verify_otp_controller.dart';

class OtpSubmitButton extends StatelessWidget {
  OtpSubmitButton({super.key});

  final verifyOtpController = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: defaultAccentColor,
      child: MaterialButton(
        onPressed: () {
          verifyOtpController.onSubmitOtpClick();
        },
        color: defaultAccentColor,
        elevation: 0,
        height: 50,
        splashColor: Colors.white.withAlpha(30),
        child: Text('submit'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
      ),
    );
  }
}
