import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/add_photo_view.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/add_product_button.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/add_product_photos_list.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/add_product_photos_title_view.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/pack_off_view.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_barcode.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_category.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_cutoff.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_description.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_manufacturer.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_name.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_price.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_supplier.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_title.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/textfield_product_uuid.dart';
import 'package:otm_inventory/pages/products/add_stock_product/view/widgets/title_text_view.dart';
import 'package:otm_inventory/widgets/custom_switch.dart';

import '../../../../res/colors.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/appbar/base_appbar.dart';
import '../controller/add_stock_product_controller.dart';

class AddStockProductScreen extends StatelessWidget {
  AddStockProductScreen({super.key});

  final addStockProductController = Get.put(AddStockProductController());

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
            title: addStockProductController.title.value,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: addStockProductController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Visibility(
                visible: addStockProductController.isMainViewVisible.value,
                child: Column(children: [
                  const Divider(),
                  Form(
                    key: addStockProductController.formKey,
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              TitleTextView(title: 'product_info'.tr),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 14, 14, 8),
                                child: Row(
                                  children: [
                                    AddPhotoView(),
                                    const SizedBox(
                                      width: 14,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TextFieldStockProductName(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          TextFieldStockProductTitle(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              AddStockProductPhotosList(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(14, 14, 14, 18),
                                child: Divider(
                                  height: 0,
                                  color: dividerColor,
                                ),
                              ),
                              TitleTextView(title: 'classification'.tr),
                              const SizedBox(
                                height: 14,
                              ),
                              TextFieldStockProductCategory(),
                              TextFieldStockProductSupplier(),
                              TextFieldStockProductManufacturer(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(14, 8, 14, 18),
                                child: Divider(
                                  height: 0,
                                  color: dividerColor,
                                ),
                              ),
                              TitleTextView(title: 'inventory'.tr),
                              const SizedBox(
                                height: 14,
                              ),
                              TextFieldStockProductCutoff(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(14, 8, 14, 18),
                                child: Divider(
                                  height: 0,
                                  color: dividerColor,
                                ),
                              ),
                              TitleTextView(title: 'other_info'.tr),
                              const SizedBox(
                                height: 14,
                              ),
                              TextFieldStockProductUuid(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: TextFieldStockProductBarCode()),
                                  // QrCodeIconAddStockProduct()
                                ],
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              TextFieldStockProductPrice(),
                              TextFieldStockProductDescription(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(14, 8, 14, 18),
                                child: Divider(
                                  height: 0,
                                  color: dividerColor,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleTextView(title: 'pack_off'.tr),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 11),
                                    child: Switch(
                                      activeColor: activeSwitchThumbColor,
                                      activeTrackColor: activeSwitchColor,
                                      value: addStockProductController
                                          .isPackOffEnable.value,
                                      onChanged: (value) {
                                        addStockProductController
                                            .isPackOffEnable.value = value;
                                        addStockProductController
                                            .isSaveEnable.value = true;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              PackOffView()
                              // AddProductPhotosTitleView(),
                              // AddProductPhotosList(),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 14, bottom: 18),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         'status'.tr,
                              //         style: const TextStyle(
                              //             fontSize: 16, color: primaryTextColor),
                              //       ),
                              //       const SizedBox(
                              //         width: 4,
                              //       ),
                              //       Switch(
                              //           value: addStockProductController
                              //               .isStatus.value,
                              //           activeColor: defaultAccentColor,
                              //           onChanged: (isVisible) {
                              //             addStockProductController
                              //                 .isStatus.value = isVisible;
                              //           })
                              //     ],
                              //   ),
                              // )
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
      ),
    );
  }
}
