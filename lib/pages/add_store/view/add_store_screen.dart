import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/add_store_button.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/text_field_store_phone_extension.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/textfield_store_address.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/textfield_store_manager.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/textfield_store_name.dart';
import 'package:otm_inventory/pages/add_store/view/widgets/textfield_store_phone_number.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../controller/add_store_controller.dart';

class AddStoreScreen extends StatelessWidget {
  AddStoreScreen({super.key});

  final addStoreController = Get.put(AddStoreController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: addStoreController.title.value,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: addStoreController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: addStoreController.isMainViewVisible.value,
              child: Column(children: [
                Form(
                  key: addStoreController.formKey,
                  child: Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            TextFieldStoreName(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(flex: 3,child: TextFieldStorePhoneExtension(),),
                                Flexible(flex: 4, child: TextFieldPhoneNumber()),
                              ],
                            ),
                            TextFieldStoreAddress(),
                            TextFieldStoreManager(),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 14,bottom: 18),
                            //   child: Row(
                            //     children: [
                            //       Text('status'.tr,style: const TextStyle(fontSize: 16,color: primaryTextColor),),
                            //       const SizedBox(width: 4,),
                            //       Switch(
                            //           value: addStoreController.isStatus.value,
                            //           activeColor: defaultAccentColor,
                            //           onChanged: (isVisible) {
                            //             addStoreController.isStatus.value =
                            //                 isVisible;
                            //           })
                            //     ],
                            //   ),
                            // )
                          ]),
                    ),
                  ),
                ),
                AddStoreButton()
              ]),
            ),
          );
        }),
      ),
    );
  }
}
