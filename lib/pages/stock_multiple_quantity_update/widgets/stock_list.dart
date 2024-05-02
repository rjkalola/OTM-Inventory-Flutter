import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../../widgets/text_field_border.dart';

class StockMultipleQuantityUpdateListView extends StatelessWidget {
  StockMultipleQuantityUpdateListView({super.key});

  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                stockListController.productList.length,
                (position) => InkWell(
                  onTap: () {},
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
                                          .productList[position].name!,
                                      style: const TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                ),
                                const SizedBox(width: 8),
                                quantityWidget(position)
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
                            const SizedBox(
                              height: 8,
                            ),
                            quantityUpdateWidget(position)
                          ],
                        ),
                      )),
                    ]),
                  )),
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
      child: Text(stockListController.productList[position].qty!.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: defaultAccentColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )),
    );
  }

  Widget quantityUpdateWidget(int position) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (!StringHelper.isEmptyString(stockListController
                    .productList[position].newQty
                    .toString()) &&
                stockListController.productList[position].newQty! > 0) {

              stockListController.productList[position].newQty =
                  stockListController.productList[position].newQty! - 1;
              stockListController.controllers[position].text = stockListController.productList[position].newQty.toString();

              print("Qty:"+stockListController.productList[position].newQty.toString());
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                color: defaultAccentColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: SizedBox(
            width: 50,
            child: TextFormField(
              controller: stockListController.controllers[position],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              validator: MultiValidator([]),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: InputDecoration(
                  isDense: true,
                  // important line
                  contentPadding: const EdgeInsets.all(4),
                  hintText: "0",
                  // control your hints text size
                  border: border(),
                  focusedBorder: border(),
                  enabledBorder: border()),
              onChanged: (value) {
                print("position:"+position.toString());
                print("value:"+value);
                if(!StringHelper.isEmptyString(value)){
                  stockListController.productList[position].newQty = int.parse(value);
                }else{
                  stockListController.productList[position].newQty =0;
                }
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // stockListController.productList[position].newQty = 1;
            // if(stockListController.productList[position].newQty == null){
            //   stockListController.productList[position].newQty = 1;
            // }else{
            //   stockListController.productList[position].newQty =
            //       stockListController.productList[position].newQty! + 1;
            // }

            stockListController.productList[position].newQty =
                stockListController.productList[position].newQty! + 1;
            stockListController.controllers[position].text = stockListController.productList[position].newQty.toString();

            print("Qty:"+stockListController.productList[position].newQty.toString());
          },
          child: Container(
            decoration: const BoxDecoration(
                color: defaultAccentColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputBorder? border() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide:
            const BorderSide(color: normalTextFieldBorderColor, width: 0.6));
  }
}
