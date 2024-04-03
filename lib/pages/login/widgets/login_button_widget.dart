import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/PrimaryButton.dart';
import '../login_controller.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
        child: PrimaryButton(
          buttonText: 'Login with OTP',
          onPressed: () {
            loginController.login();
          },
        ),
      ),
    );
  }
}
