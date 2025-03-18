import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_controller.dart';
import 'package:otm_inventory/pages/products/import_products/view/widgets/exit_button.dart';
import 'package:otm_inventory/pages/products/import_products/view/widgets/file_detils_view.dart';
import 'package:otm_inventory/pages/products/import_products/view/widgets/result_view.dart';
import 'package:otm_inventory/pages/products/import_products/view/widgets/upload_button.dart';
import 'package:otm_inventory/pages/products/import_products/view/widgets/upload_file_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class ImportProductsScreen extends StatelessWidget {
  ImportProductsScreen({super.key});

  final controller = Get.put(ImportProductsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // final backNavigationAllowed = await onBackPress();
        Get.back(result: controller.isResultVisible.value);
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'import_products'.tr,
              isCenterTitle: false,
              isBack: true,
            ),
            body: Obx(() {
              return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: Visibility(
                  visible: controller.isMainViewVisible.value,
                  child: Column(children: [
                    const Divider(),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UploadFileView(),
                            FileDetailsView(),
                            ResultView()
                          ]),
                    ),
                    UploadButton(),
                    ExitButton()
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
