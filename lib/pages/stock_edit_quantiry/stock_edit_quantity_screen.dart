import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/qty_history_list_view.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/save_stock_quantity_button.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_stock_quantity.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../res/colors.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_constants.dart';
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
          title: 'edit_stock'.tr,
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
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffc6c6c6)),
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: ImageUtils.setImage(
                                        stockEditQuantityController.productInfo
                                                .value.imageThumbUrl ??
                                            "",
                                        68),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextView(
                                          stockEditQuantityController
                                                  .productInfo
                                                  .value
                                                  .shortName ??
                                              "",
                                          18,
                                          FontWeight.w600,
                                          primaryTextColor,
                                          const EdgeInsets.all(0),
                                          () => {}),
                                      customTextView(
                                          stockEditQuantityController
                                                  .productInfo
                                                  .value
                                                  .supplier_code ??
                                              "",
                                          15,
                                          FontWeight.w400,
                                          primaryTextColorLight,
                                          const EdgeInsets.all(0),
                                          () => {}),
                                      customTextView(
                                          "${'qty_in_stock'.tr}: ${stockEditQuantityController.productInfo.value.qty ?? 0.toString()}",
                                          15,
                                          FontWeight.w400,
                                          primaryTextColorLight,
                                          const EdgeInsets.all(0),
                                          () => {})
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          dividerItem(),
                          customTextView(
                              stockEditQuantityController
                                      .productInfo.value.name ??
                                  "",
                              18,
                              FontWeight.w600,
                              primaryTextColor,
                              const EdgeInsets.fromLTRB(18, 14, 18, 14),
                              () => {}),
                          dividerItem(),
                          customTextView(
                              stockEditQuantityController
                                      .productInfo.value.supplier_name ??
                                  "",
                              16,
                              FontWeight.w500,
                              primaryTextColor,
                              const EdgeInsets.fromLTRB(18, 14, 18, 14),
                              () => {}),
                          dividerItem(),
                          Visibility(
                            visible: !StringHelper.isEmptyList(stockEditQuantityController.productInfo.value.stock_histories),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  customTextView(
                                      'stock_movement'.tr,
                                      17,
                                      FontWeight.w500,
                                      primaryTextColorLight,
                                      const EdgeInsets.all(0),
                                      () => {}),
                                  customTextView(
                                      'view_more_'.tr,
                                      15,
                                      FontWeight.w500,
                                      defaultAccentColor,
                                      const EdgeInsets.all(0), () {
                                    var arguments = {
                                      AppConstants.intentKey.productId:
                                          stockEditQuantityController.productId,
                                    };
                                    Get.toNamed(
                                        AppRoutes.stockQuantityHistoryScreen,
                                        arguments: arguments);
                                  })
                                ],
                              ),
                            ),
                          ),
                          QtyHistoryListView()
                        ]),
                  ),
                ),
                Form(
                  key: stockEditQuantityController.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: dividerColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      customTextView(
                          'add_quantity_in_numbers'.tr,
                          16,
                          FontWeight.w400,
                          primaryTextColor,
                          const EdgeInsets.fromLTRB(18, 0, 18, 12),
                          () => {}),
                      // TextFieldQuantityUpdateNote(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFieldQuantity(),
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

  Widget customTextView(String? text, double fontSize, FontWeight? fontWeight,
          Color color, EdgeInsetsGeometry padding, VoidCallback onPressed) =>
      Visibility(
        visible: !StringHelper.isEmptyString(text),
          child: Flexible(
            child: InkWell(
              onTap: () {
                onPressed();
              },
              child: Padding(
                padding: padding,
                child: Text(text ?? "",
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: color,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    )),
              ),
            ),
          ),
      );

  Widget dividerItem() => const Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor,
      );
}
