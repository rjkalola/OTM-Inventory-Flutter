import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_controller.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/otp_box_widget.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/otp_submit_button.dart';
import 'package:otm_inventory/pages/otp_verification/widgets/resend_view_widget.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/save_stock_quantity_button.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_quantity_update_note.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_stock_quantity.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../res/colors.dart';
import '../../widgets/CustomProgressbar.dart';
import '../../widgets/appbar/base_appbar.dart';

class StockEditQuantityScreen extends StatefulWidget {
  const StockEditQuantityScreen({
    super.key,
  });

  @override
  State<StockEditQuantityScreen> createState() =>
      _StockEditQuantityScreenState();
}

class _StockEditQuantityScreenState extends State<StockEditQuantityScreen> {
  final stockEditQuantityController = Get.put(StockEditQuantityController());

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
          title: 'edit_quantity'.tr,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: stockEditQuantityController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: stockEditQuantityController.isMainViewVisible.value,
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: dividerColor,
                          ),
                          const SizedBox(height: 10,),
                          rowItemDetail(
                              'name'.tr,
                              stockEditQuantityController
                                      .productInfo.value.name ??
                                  "-"),
                          dividerItem(),
                          rowItemDetail(
                              'short_name'.tr,
                              stockEditQuantityController
                                      .productInfo.value.shortName ??
                                  "-"),
                          dividerItem(),
                          rowItemDetail(
                              'sku'.tr,
                              stockEditQuantityController
                                      .productInfo.value.sku ??
                                  "-"),
                          dividerItem(),
                          rowItemDetail(
                              'model'.tr,
                              stockEditQuantityController
                                      .productInfo.value.model_name ??
                                  "-"),
                          dividerItem(),
                          rowItemDetail(
                              'manufacturer'.tr,
                              stockEditQuantityController
                                      .productInfo.value.manufacturer_name ??
                                  "-"),
                          dividerItem(),
                          rowItemDetail(
                              'dimension_hwl'.tr,
                              getDimension()),
                          dividerItem(),
                          rowItemDetail('weight'.tr, getWeight()),
                          dividerItem(),
                        ]),
                  ),
                ),
                Form(
                  key: stockEditQuantityController.formKey,
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: dividerColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFieldQuantityUpdateNote(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  stockEditQuantityController
                                      .decreaseQuantity();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffc6c6c6)),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.remove,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              TextFieldQuantity(),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  stockEditQuantityController
                                      .increaseQuantity();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffc6c6c6)),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      SaveStockQuantityButton()
                    ],
                  ),
                )
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget rowItemDetail(String title, String value) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleTextView(title),
            const SizedBox(width: 14),
            valueTextView(value)
          ],
        ),
      );

  Widget titleTextView(String? text) => Text(text ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ));

  Widget valueTextView(String? text) => Flexible(
        child: Text(text ?? "",
            softWrap: true,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            )),
      );

  Widget dividerItem() => const Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor,
      );

  String getWeight() {
    String weight = "-";
    if (!StringHelper.isEmptyString(
            stockEditQuantityController.productInfo.value.weight) &&
        !StringHelper.isEmptyString(
            stockEditQuantityController.productInfo.value.weight_unit_name)) {
      weight = stockEditQuantityController.productInfo.value.weight! +" "+
          stockEditQuantityController.productInfo.value.weight_unit_name!;
    }
    return weight;
  }

  String getDimension() {
    String dimension = "-";
    if (!StringHelper.isEmptyString(
        stockEditQuantityController.productInfo.value.height) &&
        !StringHelper.isEmptyString(
            stockEditQuantityController.productInfo.value.width) && !StringHelper.isEmptyString(
        stockEditQuantityController.productInfo.value.length)&& !StringHelper.isEmptyString(
        stockEditQuantityController.productInfo.value.length_unit_name)) {
      dimension = "${stockEditQuantityController.productInfo.value.height!}*${stockEditQuantityController.productInfo.value.width!}*${stockEditQuantityController.productInfo.value.length!} ${stockEditQuantityController.productInfo.value.length_unit_name!}";
    }
    return dimension;
  }
}