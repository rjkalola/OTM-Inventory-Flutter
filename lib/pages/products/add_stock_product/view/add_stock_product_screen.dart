import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/add_product_button.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_supplier.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/add_product_button.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_name.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_title.dart';

import '../../../../res/colors.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/appbar/base_appbar.dart';
import '../controller/add_stock_product_controller.dart';

class AddStockProductScreen extends StatelessWidget {
  AddStockProductScreen({super.key});

  final addProductController = Get.put(AddStockProductController());

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
          title: addProductController.title.value,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: addProductController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: addProductController.isMainViewVisible.value,
              child: Column(children: [
                Form(
                  key: addProductController.formKey,
                  child: Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            TextFieldStockProductName(),
                            TextFieldStockProductTitle(),
                            TextFieldProductSupplier(),
                            // AddProductPhotosTitleView(),
                            // AddProductPhotosList(),
                            Padding(
                              padding: const EdgeInsets.only(left: 14,bottom: 18),
                              child: Row(
                                children: [
                                  Text('status'.tr,style: const TextStyle(fontSize: 16,color: primaryTextColor),),
                                  const SizedBox(width: 4,),
                                  Switch(
                                      value: addProductController.isStatus.value,
                                      activeColor: defaultAccentColor,
                                      onChanged: (isVisible) {
                                        addProductController.isStatus.value =
                                            isVisible;
                                      })
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
                AddStockProductButton()
              ]),
            ),
          );
        }),
      ),
    );
  }
}
