import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import '../../../../res/colors.dart';
import '../stock_quantity_history_controller.dart';

class QtyHistoryListView extends StatelessWidget {
  QtyHistoryListView({super.key});

  final stockQuantityHistoryController = Get.put(StockQuantityHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockQuantityHistoryController.stockQuantityHistoryResponse.value.info!.isNotEmpty,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              stockQuantityHistoryController.stockQuantityHistoryResponse.value.info!.length,
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
                          stockQuantityHistoryController.stockQuantityHistoryResponse.value.info![position].created_at_formatted,
                          16,
                          FontWeight.w400,
                          primaryTextColorLight,
                          const EdgeInsets.all(0)),
                      customTextView(
                          stockQuantityHistoryController.stockQuantityHistoryResponse.value.info![position].qty,
                          16,
                          FontWeight.w400,
                          (int.parse(stockQuantityHistoryController.stockQuantityHistoryResponse.value.info![position].qty!)>0)?Colors.green:Colors.red,
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
