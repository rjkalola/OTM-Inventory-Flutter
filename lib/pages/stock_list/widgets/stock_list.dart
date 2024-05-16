import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../../widgets/PrimaryBorderButton.dart';

class StockListView extends StatelessWidget {
  StockListView({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              controller: stockListController.controller,
              scrollDirection: Axis.vertical,
              children: List.generate(
                stockListController.productList.length,
                (position) => InkWell(
                  onTap: () {
                    stockListController.moveStockEditQuantityScreen(
                        stockListController.productList[position].id!
                            .toString());
                  },
                  child: CardView(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child: Row(children: [
                      stockListController.productList[position].imageThumb !=
                              null
                          ? Image.network(
                              stockListController
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
                                      stockListController
                                          .productList[position].shortName!,
                                      style: const TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                ),
                                const SizedBox(width: 8),
                                setTopRightWidget(position)
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Visibility(
                              visible: !StringHelper.isEmptyString(
                                  stockListController
                                      .productList[position].barcode_text),
                              child: Text(
                                  "${'barcode'.tr}: ${stockListController.productList[position].barcode_text ?? ""}",
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
                                  stockListController
                                      .productList[position].supplier_code),
                              child: Text(
                                  "${'product_id'.tr}: ${stockListController.productList[position].supplier_code ?? ""}",
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

  Widget setTopRightWidget(int position){
    if(!stockListController.isLoading.value & stockListController.isScanQrCode.value){
      if(!StringHelper.isEmptyString(stockListController
          .productList[position].barcode_text)){
        print("Barcode");
        return quantityWidget(position);
      }else{
        print("select button");
        return selectButtonWidget(position);
      }
    }else{
      return quantityWidget(position);
    }
  }

  Widget quantityWidget(int position) {
      return Visibility(
        visible: !StringHelper.isEmptyString(
            stockListController
                .productList[position].qty.toString()),
        child: Text(
            stockListController.productList[position].qty!.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: defaultAccentColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            )),
      );
  }

  Widget selectButtonWidget(int position){
      return SizedBox(
        width: 70,
        child: PrimaryBorderButton(
          buttonText: 'select'.tr,
          textColor: defaultAccentColor,
          borderColor: defaultAccentColor,
          height: 30,
          fontSize: 14,
          onPressed: () {
          stockListController.onClickSelectButton(stockListController.productList[position]);
          },
        ),
      );
  }
}
