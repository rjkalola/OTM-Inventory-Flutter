import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/login_controller.dart';
import 'package:otm_inventory/pages/login/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/login/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/web_services/response/status.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../res/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: 'login'.tr,
        isBack: false,
      ),
      body: Obx(() {
        if(loginController.isInternetNotAvailable.value){
          return const Center(child: Text("No Internet"),);
        }else{
          if(loginController.isLoading.value){
            return CustomProgressbar();
          }else{
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
                    child: Text('phone_number'.tr,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        )),
                  ),
                  Form(
                    key: loginController.formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Row(children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Image.network(
                                loginController.mFlag.value,
                                width: 32,
                                height: 32,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                              color: Color(0xff000000),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Text(loginController.mExtension.value,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                            ),
                          ]),
                          onTap: () {},
                        ),
                        PhoneTextFieldWidget(),
                      ],
                    ),
                  ),
                  LoginButtonWidget()
                ]);
          }
        }
      }),
    );
  }
}
