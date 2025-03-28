import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/row_reference_users.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/save_stock_quantity_button.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_stock_quantity.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../res/colors.dart';
import '../../res/drawable.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/image_utils.dart';
import '../../widgets/CustomProgressbar.dart';
import '../../widgets/appbar/base_appbar.dart';
import '../../widgets/image/cached_image.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final backNavigationAllowed = await Future.value(true);
        if (backNavigationAllowed) {
          onBackPress();
        }
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'edit_stock'.tr,
              isCenterTitle: false,
              isBack: true,
              widgets: actionButtons(),
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
                                padding:
                                    const EdgeInsets.fromLTRB(14, 0, 4, 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xffc6c6c6)),
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: InkWell(
                                          onTap: () {
                                            ImageUtils.showImagePreviewDialog(
                                                stockEditQuantityController
                                                        .productInfo
                                                        .value
                                                        .imageThumbUrl ??
                                                    "");
                                          },
                                          child: CachedImage(
                                            width: 60,
                                            height: 60,
                                            placeHolderSize: 60,
                                            url: stockEditQuantityController
                                                    .productInfo
                                                    .value
                                                    .imageThumbUrl ??
                                                "",
                                          ),
                                        ),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible:
                                                    !StringHelper.isEmptyString(
                                                        stockEditQuantityController
                                                            .productInfo
                                                            .value
                                                            .supplier_code),
                                                child: Text(
                                                    "${stockEditQuantityController.productInfo.value.supplier_code ?? ""}, ${stockEditQuantityController.productInfo.value.uuid ?? ""}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color:
                                                          secondaryLightTextColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13,
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 14),
                                                child: Text(
                                                    "${stockEditQuantityController.productInfo.value.currency ?? ""}${stockEditQuantityController.productInfo.value.price ?? ""}",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color:
                                                          secondaryLightTextColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13,
                                                    )),
                                              )
                                            ],
                                          ),
                                          // customTextView(
                                          //     "${stockEditQuantityController.productInfo.value.supplier_code ?? ""}, ${stockEditQuantityController.productInfo.value.uuid ?? ""}",
                                          //     14,
                                          //     FontWeight.w400,
                                          //     primaryTextColorLight,
                                          //     const EdgeInsets.all(0),
                                          //     () => {}),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              customTextView(
                                                  "${'qty_in_stock'.tr}:",
                                                  14,
                                                  FontWeight.w400,
                                                  primaryTextColorLight,
                                                  const EdgeInsets.all(0),
                                                  () => {}),
                                              customTextView(
                                                  stockEditQuantityController
                                                              .productInfo
                                                              .value
                                                              .qty !=
                                                          null
                                                      ? stockEditQuantityController
                                                          .productInfo.value.qty
                                                          .toString()
                                                      : "0",
                                                  20,
                                                  FontWeight.w600,
                                                  primaryTextColorLight,
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 16, 0),
                                                  () => {})
                                            ],
                                          )
                                          // !StringHelper.isEmptyString(
                                          //         stockEditQuantityController
                                          //             .productInfo
                                          //             .value
                                          //             .barcode_text)
                                          //     ? Row(
                                          //         children: [
                                          //           customTextView(
                                          //               "${'barcode'.tr}: ${stockEditQuantityController.productInfo.value.barcode_text ?? ""}",
                                          //               14,
                                          //               FontWeight.w400,
                                          //               primaryTextColorLight,
                                          //               const EdgeInsets.all(0),
                                          //               () {
                                          //             stockEditQuantityController
                                          //                 .showUpdateBarcodeManually(
                                          //                     stockEditQuantityController
                                          //                             .productInfo
                                          //                             .value
                                          //                             .barcode_text ??
                                          //                         "");
                                          //           }),
                                          //           const SizedBox(
                                          //             width: 4,
                                          //           ),
                                          //           InkWell(
                                          //               onTap: () {
                                          //                 stockEditQuantityController
                                          //                     .showUpdateBarcodeManually(
                                          //                         stockEditQuantityController
                                          //                                 .productInfo
                                          //                                 .value
                                          //                                 .barcode_text ??
                                          //                             "");
                                          //               },
                                          //               child: const Icon(
                                          //                 Icons.edit,
                                          //                 color:
                                          //                     defaultAccentColor,
                                          //                 size: 16,
                                          //               ))
                                          //         ],
                                          //       )
                                          //     : Container()
                                        ],
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   width: 6,
                                    // ),
                                    // QrCodeIconEditStock()
                                  ],
                                ),
                              ),
                              dividerItem(),
                              customTextView(
                                  stockEditQuantityController
                                          .productInfo.value.name ??
                                      "",
                                  15,
                                  FontWeight.w500,
                                  primaryTextColor,
                                  const EdgeInsets.fromLTRB(18, 14, 18, 14),
                                  () => {}),
                              dividerItem(),
                              customTextView(
                                  stockEditQuantityController
                                          .productInfo.value.supplier_name ??
                                      "",
                                  15,
                                  FontWeight.w500,
                                  primaryTextColor,
                                  const EdgeInsets.fromLTRB(18, 14, 18, 14),
                                  () => {}),
                              dividerItem(),
                              Visibility(
                                visible: !StringHelper.isEmptyString(
                                    stockEditQuantityController
                                            .productInfo.value.description ??
                                        ""),
                                child: customTextView(
                                    stockEditQuantityController
                                            .productInfo.value.description ??
                                        "",
                                    15,
                                    FontWeight.w500,
                                    primaryTextColor,
                                    const EdgeInsets.fromLTRB(18, 14, 18, 14),
                                    () => {}),
                              ),
                              Visibility(
                                  visible: !StringHelper.isEmptyString(
                                      stockEditQuantityController
                                              .productInfo.value.description ??
                                          ""),
                                  child: dividerItem()),
                              // TextFieldStockPrice(),
                              // TextFieldEditStockDate(),
                              // dividerItem(),
                              // Visibility(
                              //   visible: !StringHelper.isEmptyList(
                              //       stockEditQuantityController
                              //           .productInfo.value.stock_histories),
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         customTextView(
                              //             'stock_movement'.tr,
                              //             17,
                              //             FontWeight.w500,
                              //             primaryTextColorLight,
                              //             const EdgeInsets.all(0),
                              //             () => {}),
                              //         customTextView(
                              //             'view_more_'.tr,
                              //             15,
                              //             FontWeight.w500,
                              //             defaultAccentColor,
                              //             const EdgeInsets.all(0), () {
                              //           var arguments = {
                              //             AppConstants.intentKey.productId:
                              //                 stockEditQuantityController
                              //                     .productId,
                              //           };
                              //           Get.toNamed(
                              //               AppRoutes.stockQuantityHistoryScreen,
                              //               arguments: arguments);
                              //         })
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // QtyHistoryListView()
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
                            height: 14,
                          ),
                          // customTextView(
                          //     'add_quantity'.tr,
                          //     16,
                          //     FontWeight.w400,
                          //     primaryTextColor,
                          //     const EdgeInsets.fromLTRB(18, 0, 18, 6),
                          //     () => {}),
                          RowReferenceUsers(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      String text = stockEditQuantityController
                                          .quantityController.value.text;
                                      if (stockEditQuantityController
                                          .isAddQtyVisible.value) {
                                        if (text.startsWith("+")) {
                                          String newText =
                                              text.substring(1, text.length);
                                          text = newText;
                                        }
                                        if (!text.startsWith("-")) {
                                          String newText = "-$text";
                                          print("new text:" + newText);
                                          stockEditQuantityController
                                              .quantityController
                                              .value
                                              .text = newText;
                                        }
                                        stockEditQuantityController
                                            .isAddQtyVisible.value = false;
                                        stockEditQuantityController
                                            .isDeductQtyVisible.value = true;
                                      } else {
                                        if (text.startsWith("-")) {
                                          String newText =
                                              text.substring(1, text.length);
                                          text = newText;
                                          stockEditQuantityController
                                              .quantityController
                                              .value
                                              .text = newText;
                                        }
                                        // if (!text.startsWith("+")) {
                                        //   String newText = "+$text";
                                        //   print("new text:" + newText);
                                        //   stockEditQuantityController
                                        //       .quantityController
                                        //       .value
                                        //       .text = newText;
                                        // }
                                        stockEditQuantityController
                                            .isAddQtyVisible.value = true;
                                        stockEditQuantityController
                                            .isDeductQtyVisible.value = false;
                                      }
                                    },
                                    child: Container(
                                      // color of
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: rectangleBorderColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              4)), // grid items
                                      child: const Padding(
                                        padding: EdgeInsets.all(9.0),
                                        child: Text(
                                          "+/-",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(flex: 1, child: TextFieldQuantity()),
                                  SaveStockQuantityButton()
                                ]),
                          ),
                          // SaveStockQuantityButton()
                        ],
                      ),
                    )
                  ]),
                ),
              );
            }),
          ),
        ),
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

  List<Widget>? actionButtons() {
    return [
      // IconButton(
      //   icon: SvgPicture.asset(
      //     width: 28,
      //     Drawable.deleteIcon,
      //     colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
      //   ),
      //   onPressed: () {
      //     stockEditQuantityController.onClickRemove();
      //   },
      // ),
      Visibility(
        visible:
            AppUtils.isPermission(AppStorage().getPermissions().updateProduct),
        child: IconButton(
          icon: SvgPicture.asset(
            width: 26,
            Drawable.editIcon,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            stockEditQuantityController.editProductClick();
          },
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      IconButton(
        icon: SvgPicture.asset(
          width: 26,
          Drawable.historyIcon,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        onPressed: () {
          var arguments = {
            AppConstants.intentKey.productId:
                stockEditQuantityController.productId,
          };
          Get.toNamed(AppRoutes.stockQuantityHistoryScreen,
              arguments: arguments);
        },
      ),
      const SizedBox(
        width: 20,
      )
      // IconButton(
      //   icon: SvgPicture.asset(
      //     width: 26,
      //     Drawable.barCodeIcon,
      //   ),
      //   onPressed: () {
      //     stockEditQuantityController.onClickQrCode();
      //   },
      // ),
      // InkWell(
      //     onTap: () {
      //       stockEditQuantityController.addMultipleStockQuantity();
      //     },
      //     child: Padding(
      //       padding: const EdgeInsets.only(right: 14),
      //       child: Text(
      //         "+${'add_stock'.tr}",
      //         style: const TextStyle(
      //             fontSize: 16,
      //             color: defaultAccentColor,
      //             fontWeight: FontWeight.w500),
      //       ),
      //     )),
    ];
  }

  void onBackPress() {
    if (stockEditQuantityController.isUpdated) {
      Get.back(result: true);
    } else {
      Get.back();
    }
  }
}
