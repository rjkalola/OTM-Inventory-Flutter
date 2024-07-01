import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/widgets/image_preview_dialog.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/AlertDialogHelper.dart';
import '../../../../../utils/app_storage.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/image_utils.dart';
import '../../../../../widgets/image/cached_image.dart';
import '../../controller/product_list_controller.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final productListController = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: productListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: productListController.controller,
              children: List.generate(
                productListController.productList.length,
                (position) => InkWell(
                  onTap: () {
                    if (!productListController.isPrintEnable.value) {
                      if (AppUtils.isPermission(
                          AppStorage().getPermissions().updateProduct)) {
                        productListController.addProductClick(
                            productListController.productList[position]);
                      }
                    } else {
                      bool check = productListController
                              .productList[position].checkPrint ??
                          false;
                      productListController.productList[position].checkPrint =
                          !check;
                      productListController.productList.refresh();
                    }
                  },
                  child: CardView(
                      child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              ImageUtils.showImagePreviewDialog(
                                  productListController
                                      .productList[position].imageUrl);
                            },
                            child: CachedImage(
                              url: productListController
                                  .productList[position].imageThumbUrl,
                              width: 60,
                              height: 60,
                              placeHolderSize: 60,
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                          softWrap: true,
                                          productListController
                                                  .productList[position]
                                                  .shortName ??
                                              "",
                                          style: const TextStyle(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          )),
                                    ),
                                    const SizedBox(width: 8),
                                    Visibility(
                                      visible: !StringHelper.isEmptyString(
                                          productListController
                                              .productList[position].qty
                                              .toString()),
                                      child: SizedBox(
                                        width: 70,
                                        child: Text(
                                            productListController
                                                .productList[position].qty
                                                .toString(),
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: defaultAccentColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Visibility(
                                  visible: !StringHelper.isEmptyString(
                                      productListController
                                          .productList[position].supplier_name),
                                  child: Text(
                                      "${'supplier_name'.tr}: ${productListController.productList[position].supplier_name ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: secondaryLightTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      )),
                                ),
                                Visibility(
                                  visible: !StringHelper.isEmptyString(
                                      productListController
                                          .productList[position].supplier_code),
                                  child: Text(
                                      "${'supplier_code'.tr}: ${productListController.productList[position].supplier_code ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: secondaryLightTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      )),
                                ),
                              ],
                            ),
                          )),
                          // Row(
                          //   children: [
                          //     Text("7 December",
                          //         style: TextStyle(
                          //             color: secondaryExtraLightTextColor,
                          //             fontSize: 12)),
                          //     SizedBox(
                          //       width: 11,
                          //     ),
                          //     // Container(
                          //     //   decoration: BoxDecoration(
                          //     //       border:
                          //     //           Border.all(color: Color(0xffc6c6c6), width: 0.5),
                          //     //       borderRadius: BorderRadius.circular(4)),
                          //     //   child: Padding(
                          //     //     padding: const EdgeInsets.all(3.0),
                          //     //     child: SvgPicture.asset(
                          //     //       width: 22,
                          //     //       "assets/images/ic_map_pin.svg",
                          //     //     ),
                          //     //   ),
                          //     // )
                          //   ],
                          // ),
                        ]),
                      ),
                      Visibility(
                        visible: productListController.isPrintEnable.value,
                        child: Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Checkbox(
                                activeColor: defaultAccentColor,
                                value: productListController
                                        .productList[position].checkPrint ??
                                    false,
                                onChanged: (isCheck) {
                                  print("Check:" + isCheck.toString());
                                  productListController.productList[position]
                                      .checkPrint = isCheck;
                                  productListController.productList.refresh();
                                }),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ),
            ),
          ),
        ));
  }
}
