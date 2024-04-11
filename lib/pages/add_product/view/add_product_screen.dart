import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/add_product_button.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_category.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_description.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_height.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_length.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_length_unit.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_manufacturer.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_model.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_name.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_price.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_sku.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_supplier.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_tax.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_title.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_weight.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_weight_unit.dart';
import 'package:otm_inventory/pages/add_product/view/widgets/textfield_product_width.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'add_product'.tr,
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
                            TextFieldProductName(),
                            TextFieldProductTitle(),
                            TextFieldProductCategory(),
                            TextFieldProductSupplier(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                              child: Text('dimensions_'.tr,
                                  style: const TextStyle(
                                      color: primaryTextColor, fontSize: 16)),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFieldProductLength(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFieldProductWidth(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFieldProductHeight(),
                                ),
                              ],
                            ),
                            TextFieldProductLengthUnit(),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFieldProductWeight(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFieldProductWeightUnit(),
                                ),
                              ],
                            ),
                            TextFieldProductManufacturer(),
                            TextFieldProductModel(),
                            TextFieldProductSku(),
                            TextFieldProductPrice(),
                            TextFieldProductTax(),
                            TextFieldProductDescription(),
                          ]),
                    ),
                  ),
                ),
                AddProductButton()
              ]),
            ),
          );
        }),
      ),
    );
  }
}
