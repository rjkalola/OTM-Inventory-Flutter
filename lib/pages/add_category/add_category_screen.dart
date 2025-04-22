import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_category/widgets/add_category_button.dart';
import 'package:otm_inventory/pages/add_category/widgets/image_select_icon.dart';
import 'package:otm_inventory/pages/add_category/widgets/text_select_icon_title.dart';
import 'package:otm_inventory/pages/add_category/widgets/textfield_category_name.dart';
import 'package:otm_inventory/pages/add_category/widgets/textfield_parent_category.dart';
import 'package:otm_inventory/res/drawable.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../../widgets/appbar/base_appbar.dart';
import 'add_category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final addCategoryController = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: addCategoryController.title.value,
            isCenterTitle: false,
            isBack: true,
            widgets: actionButtons(),
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
                              TextFieldParentCategory(),
                              SelectIconTitle(),
                              ImageSelectIcon()
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
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: addCategoryController.isDeleteVisible.value,
        child: IconButton(
          icon: SvgPicture.asset(
            width: 28,
            Drawable.deleteIcon,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          onPressed: () {
            addCategoryController.onClickRemoveCategory();
          },
        ),
      ),
    ];
  }
}
