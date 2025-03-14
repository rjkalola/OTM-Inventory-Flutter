import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/add_product_button.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/add_product_photos_list.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/add_product_photos_title_view.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_barcode.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_category.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_description.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_height.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_length.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_length_unit.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_manufacturer.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_model.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_name.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_price.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_sku.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_supplier.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_tax.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_title.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_weight.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_weight_unit.dart';
import 'package:otm_inventory/pages/products/add_product/view/widgets/textfield_product_width.dart';

import '../../../../res/colors.dart';
import '../../../../res/drawable.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/appbar/base_appbar.dart';
import '../controller/add_product_controller.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => Container(
          color: backgroundColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: addProductController.title.value,
                isCenterTitle: false,
                isBack: true,
                widgets: actionButtons(),
              ),
              body: ModalProgressHUD(
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
                                AddProductPhotosTitleView(),
                                AddProductPhotosList(),
                                TextFieldProductName(),
                                TextFieldProductTitle(),
                                TextFieldProductBarCode(),
                                TextFieldProductCategory(),
                                TextFieldProductSupplier(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 8, 14, 16),
                                  child: Text('dimensions_'.tr,
                                      style: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 16)),
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
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(left: 14, bottom: 18),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         'status'.tr,
                                //         style: const TextStyle(
                                //             fontSize: 16,
                                //             color: primaryTextColor),
                                //       ),
                                //       const SizedBox(
                                //         width: 4,
                                //       ),
                                //       Switch(
                                //           value:
                                //               addProductController.isStatus.value,
                                //           activeColor: defaultAccentColor,
                                //           onChanged: (isVisible) {
                                //             addProductController.isStatus.value =
                                //                 isVisible;
                                //           })
                                //     ],
                                //   ),
                                // )
                              ]),
                        ),
                      ),
                    ),
                    AddProductButton()
                  ]),
                ),
              ),
            ),
          ),
        ));
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: addProductController.isDeleteVisible.value,
        child: IconButton(
          icon: SvgPicture.asset(
            width: 28,
            Drawable.deleteIcon,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          onPressed: () {
            addProductController.onClickRemove();
          },
        ),
      ),
      Visibility(
        visible: addProductController.isDeleteVisible.value,
        child: IconButton(
          icon: SvgPicture.asset(
            width: 26,
            Drawable.barCodeIcon,
          ),
          onPressed: () {
            addProductController.onClickQrCode();
          },
        ),
      ),
      // Visibility(
      //   visible: dashboardController.selectedIndex.value == 0,
      //   child: InkWell(
      //       onTap: () {
      //         dashboardController.addMultipleStockQuantity();
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 14),
      //         child: Text(
      //           "+${'add_stock'.tr}",
      //           style: const TextStyle(
      //               fontSize: 16,
      //               color: defaultAccentColor,
      //               fontWeight: FontWeight.w500),
      //         ),
      //       )),
      // ),
    ];
  }
}
