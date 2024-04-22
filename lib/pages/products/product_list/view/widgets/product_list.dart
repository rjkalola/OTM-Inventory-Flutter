import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import '../../../../../res/colors.dart';
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
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                productListController.productList.length,
                (position) => InkWell(
                  onTap: () {
                    productListController.addProductClick(
                        productListController.productList[position]);
                  },
                  child: CardView(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child: Row(children: [
                      productListController.productList[position].imageThumb !=
                              null
                          ? Image.network(
                              productListController
                                      .productList[position].imageThumb ??
                                  "",
                              height: 60,
                              width: 60,
                            )
                          : const Icon(Icons.photo_outlined, size: 60),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                      softWrap: true,
                                      productListController
                                          .productList[position].name!,
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
                                          .productList[position].price),
                                  child: Text(
                                      "${productListController.productList[position].currency!}${productListController.productList[position].price!}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: defaultAccentColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Visibility(
                              visible: !StringHelper.isEmptyString(
                                  productListController
                                      .productList[position].sku),
                              child: Text(
                                  "${'sku'.tr}: ${productListController.productList[position].sku ?? ""}",
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
                                      .productList[position].categoryName),
                              child: Text(
                                  "${'category'.tr}: ${productListController.productList[position].categoryName ?? ""}",
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
                                      .productList[position].manufacturer_name),
                              child: Text(
                                  "${'manufacturer'.tr}: ${productListController.productList[position].manufacturer_name ?? ""}",
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
                  )),
                ),
              ),
            ),
          ),
        ));
  }
}