import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_category/widgets/add_category_button.dart';
import 'package:otm_inventory/pages/add_category/widgets/textfield_category_name.dart';
import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../../utils/app_utils.dart';
import 'add_category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final addCategoryController = Get.put(AddCategoryController());

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
          title: addCategoryController.title.value,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: addCategoryController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: addCategoryController.isMainViewVisible.value,
              child: Column(children: [
                Form(
                  key: addCategoryController.formKey,
                  child: Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            TextFieldCategoryName(),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 14,bottom: 18),
                            //   child: Row(
                            //     children: [
                            //       Text('status'.tr,style: const TextStyle(fontSize: 16,color: primaryTextColor),),
                            //       const SizedBox(width: 4,),
                            //       Switch(
                            //           value: addCategoryController.isStatus.value,
                            //           activeColor: defaultAccentColor,
                            //           onChanged: (isVisible) {
                            //             addCategoryController.isStatus.value =
                            //                 isVisible;
                            //           })
                            //     ],
                            //   ),
                            // )
                          ]),
                    ),
                  ),
                ),
                AddCategoryButton()
              ]),
            ),
          );
        }),
      ),
    );
  }
}
