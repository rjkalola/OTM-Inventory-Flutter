import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_controller.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/otp_box_widget.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/otp_submit_button.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/resend_view_widget.dart';
import '../../res/colors.dart';
import '../../utils/Utils.dart';
import '../../widgets/appbar/base_appbar.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    super.key,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final verifyOtpController = Get.put(VerifyOtpController());

  @override
  void initState() {
    // print("Extension:" + extension);
    // print("phoneNumber:" + phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: verifyOtpController.isLoading.value,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'verify_otp'.tr,
            isBack: true,
          ),
          body: Column(children: [
            Form(
              key: verifyOtpController.formKey,
              child: Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 22),
                        child: Text('verify_otp_hint1'.tr,
                            style: const TextStyle(
                                color: defaultAccentColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OtpBoxWidget(boxController: verifyOtpController.box1.value),
                            const SizedBox(
                              width: 12,
                            ),
                            OtpBoxWidget(boxController: verifyOtpController.box2.value),
                            const SizedBox(
                              width: 12,
                            ),
                            OtpBoxWidget(boxController: verifyOtpController.box3.value),
                            const SizedBox(
                              width: 12,
                            ),
                            OtpBoxWidget(boxController: verifyOtpController.box4.value),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      ResendViewWidget()
                    ]),
              ),
            ),
            OtpSubmitButton()
          ]),
        ),
      ),
    );
  }

  void resendOTP() async {
    // if (formKey.currentState!.validate()) {
    //   showProgress();
    //   LoginResponse? response =
    //       await RemoteService().login(phoneNumber, extension);
    //   hideProgress();
    //   if (response != null) {
    //     if (response.statusCode == 200) {
    //     } else {
    //       if (context.mounted) {
    //         Utils.showSnackBarMessage(context, response.detail!);
    //       }
    //     }
    //   }
    // }
  }

  void verifyOTP(String otp) async {
    // if (formKey.currentState!.validate()) {
    //   showProgress();
    //   LoginResponse? response =
    //       await RemoteService().verifyOTP(phoneNumber, extension, otp);
    //   hideProgress();
    //   if (response != null) {
    //     if (response.statusCode == 200) {
    //       DataUtils.accessToken = response.access_token!;
    //       DataUtils.refreshAccessToken = response.refresh_token!;
    //       Utils.saveRefreshAccessToken(response.access_token!);
    //       if (context.mounted) {
    //         if(fromScreen == AppConstants.fromScreens.signUp){
    //           Navigator.pushReplacement(context,
    //               MaterialPageRoute(builder: (context) {
    //                 return SearchCompanyScreen();
    //               }));
    //         }else if(fromScreen == AppConstants.fromScreens.login){
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(builder: (context) => DashboardScreen()),
    //               ModalRoute.withName("/DashboardScreen"));
    //         }
    //       }
    //     } else {
    //       if (context.mounted) {
    //         Utils.showSnackBarMessage(context, response.detail!);
    //       }
    //     }
    //   }
    // }
  }
}
