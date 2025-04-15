import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_controller.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';

class StockMultipleQuantityUpdateListView extends StatelessWidget {
  StockMultipleQuantityUpdateListView({super.key});

  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              //
              shrinkWrap: true,
              controller: stockListController.controller,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          ImageUtils.showImagePreviewDialog(stockListController
                              .productList[position].imageUrl);
                        },
                        child: ImageUtils.setRectangleCornerCachedNetworkImage(
                            url: stockListController
                                    .productList[position].imageThumbUrl ??
                                "",
                            width: 80,
                            height: 80,
                            borderRadius: 12),
                      ),
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
                                      stockListController
                                          .productList[position].shortName!,
                                      style: const TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                ),
                                // const SizedBox(width: 8),
                                // quantityWidget(position)
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            // Visibility(
                            //   visible: !StringHelper.isEmptyString(
                            //       stockListController
                            //           .productList[position].barcode_text),
                            //   child: Text(
                            //       "${'barcode'.tr}: ${stockListController.productList[position].barcode_text ?? ""}",
                            //       maxLines: 1,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: const TextStyle(
                            //         color: secondaryLightTextColor,
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: 13,
                            //       )),
                            // ),
                            Visibility(
                              visible: !StringHelper.isEmptyString(
                                  stockListController
                                      .productList[position].supplier_code),
                              child: Text(
                                  "${'code'.tr}: ${stockListController.productList[position].supplier_code ?? ""}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: secondaryLightTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  )),
                            ),
                            // const SizedBox(
                            //   height: 8,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                quantityWidget(position),
                                quantityUpdateWidget(position)
                              ],
                            ),
                            // quantityUpdateWidget(position)
                          ],
                        ),
                      )),
                    ]),
                  ),
                );
              },
              itemCount: stockListController.productList.length,
              separatorBuilder: (context, position) => const Padding(
                padding: EdgeInsets.only(left: 100),
                child: Divider(
                  height: 0,
                  color: dividerColor,
                  thickness: 0.8,
                ),
              ),
            ),
          ),
        ));
  }

  Widget quantityWidget(int position) {
    return Visibility(
      visible: !StringHelper.isEmptyString(
          stockListController.productList[position].qty.toString()),
      child: Text(
          "${'in_stock'.tr}: ${stockListController.productList[position].qty!}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          )),
    );
  }

  Widget quantityUpdateWidget(int position) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      decoration: const BoxDecoration(
          color: Color(0xfff4f4f6),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (!StringHelper.isEmptyString(stockListController
                  .productList[position].newQty
                  .toString())) {
                stockListController.productList[position].newQty =
                    stockListController.productList[position].newQty! - 1;
                stockListController.controllers[position].text =
                    stockListController.productList[position].newQty.toString();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.remove,
                color: defaultAccentColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: SizedBox(
              width: 40,
              child: TextFormField(
                controller: stockListController.controllers[position],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                validator: MultiValidator([]),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^[\d\-+]+$')),
                ],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 6, bottom: 6),
                    hintText: "0",
                    border: border(),
                    focusedBorder: border(),
                    enabledBorder: border()),
                onChanged: (value) {
                  String text =
                      stockListController.controllers[position].value.text;
                  if (text.length > 1 &&
                      (value.endsWith("-") || value.endsWith("+"))) {
                    String newText = text.substring(0, text.length - 1);
                    stockListController.controllers[position].text = newText;
                  }
                  String updatedText =
                      stockListController.controllers[position].value.text;
                  if (!StringHelper.isEmptyString(updatedText)) {
                    stockListController.productList[position].newQty =
                        int.parse(updatedText);
                  } else {
                    stockListController.productList[position].newQty = 0;
                  }
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              stockListController.productList[position].newQty =
                  stockListController.productList[position].newQty! + 1;
              stockListController.controllers[position].text =
                  stockListController.productList[position].newQty.toString();
            },
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                color: defaultAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder? border() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.6));
  }
}
