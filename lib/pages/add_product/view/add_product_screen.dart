import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/add_product_button.dart';

import '../../../res/colors.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../controller/add_product_controller.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: 'add_product'.tr,
        isCenterTitle: true,
        isBack: true,
      ),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: addProductController.isLoading.value,
          child: Column(children: [
            Form(
              key: addProductController.formKey,
              child: Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: TextFormField(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              controller: addProductController
                                  .productTitleController.value,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 16, 16, 16),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffbab8b8), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffbab8b8), width: 1),
                                ),
                                hintText: 'enter_product_title'.tr,
                                labelText: 'product_title'.tr,
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Required"),
                              ])),
                        )
                      ]),
                ),
              ),
            ),
            AddProductButton()
          ]),
        );
      }),
    );
  }
}
