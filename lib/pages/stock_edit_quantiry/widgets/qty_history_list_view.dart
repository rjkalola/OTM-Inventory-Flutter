import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/stock_edit_quantity_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import '../../../../res/colors.dart';

class QtyHistoryListView extends StatelessWidget {
  QtyHistoryListView({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !StringHelper.isEmptyList(stockEditQuantityController.productInfo.value.stock_histories),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              !StringHelper.isEmptyList(stockEditQuantityController.productInfo.value.stock_histories)?stockEditQuantityController.productInfo.value.stock_histories!.length:0,
                  (position) => InkWell(
                onTap: () {
                  // categoryListController.addCategoryClick(
                  //     categoryListController.categoryList[position]);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextView(
                          stockEditQuantityController.productInfo.value.stock_histories![position].created_at_formatted,
                          16,
                          FontWeight.w400,
                          primaryTextColorLight,
                          const EdgeInsets.all(0)),
                      customTextView(
                          stockEditQuantityController.productInfo.value.stock_histories![position].qty,
                          16,
                          FontWeight.w400,
                          (int.parse(stockEditQuantityController.productInfo.value.stock_histories![position].qty!)>0)?Colors.green:Colors.red,
                          const EdgeInsets.all(0))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget customTextView(String? text, double fontSize, FontWeight? fontWeight,
      Color color, EdgeInsetsGeometry padding) =>
      Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Flexible(
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
      );
}
