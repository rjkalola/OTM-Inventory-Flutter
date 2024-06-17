import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_history/widgets/user_info.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../../../widgets/text/PrimaryTextView.dart';
import '../stock_quantity_history_controller.dart';

class QtyHistoryListView extends StatelessWidget {
  QtyHistoryListView({super.key});

  final stockQuantityHistoryController =
      Get.put(StockQuantityHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockQuantityHistoryController.stockHistoryList.isNotEmpty,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                stockQuantityHistoryController.stockHistoryList.length,
                (position) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  PrimaryTextView(
                                    text: stockQuantityHistoryController
                                            .stockHistoryList[position]
                                            .created_at_formatted ??
                                        "",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: primaryTextColor,
                                  ),
                                  !StringHelper.isEmptyObject(
                                          stockQuantityHistoryController
                                              .stockHistoryList[position].user)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: PrimaryTextView(
                                            text: stockQuantityHistoryController
                                                    .stockHistoryList[position]
                                                    .user!
                                                    .name ??
                                                "",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : Container(),
                                  !StringHelper.isEmptyString(
                                          stockQuantityHistoryController
                                                  .stockHistoryList[position]
                                                  .reference ??
                                              "")
                                      ? InkWell(
                                          onTap: () {
                                            stockQuantityHistoryController
                                                .showNote(
                                                    stockQuantityHistoryController
                                                            .stockHistoryList[
                                                                position]
                                                            .reference ??
                                                        "");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                9, 3, 4, 3),
                                            child: SvgPicture.asset(
                                              width: 24,
                                              Drawable.descriptionIcon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.black,
                                                      BlendMode.srcIn),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  !StringHelper.isEmptyString(
                                          stockQuantityHistoryController
                                                  .stockHistoryList[position]
                                                  .reference ??
                                              "")
                                      ? Flexible(
                                          child: Text(
                                            stockQuantityHistoryController
                                                .stockHistoryList[position]
                                                .reference!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  )
                                  // QtyHistoryUserInfo(
                                  //   user: stockQuantityHistoryController
                                  //       .stockHistoryList[position].user,
                                  // )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              child: Row(
                                children: [
                                  customTextView(
                                      stockQuantityHistoryController
                                          .stockHistoryList[position].qty,
                                      18,
                                      FontWeight.w500,
                                      (!StringHelper.isEmptyString(
                                                  stockQuantityHistoryController
                                                          .stockHistoryList[
                                                              position]
                                                          .qty ??
                                                      "") &&
                                              int.parse(
                                                      stockQuantityHistoryController
                                                              .stockHistoryList[
                                                                  position]
                                                              .qty ??
                                                          "0") >
                                                  0)
                                          ? Colors.green
                                          : Colors.red,
                                      const EdgeInsets.all(0)),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Flexible(
                                    child: Text(
                                      getUpdatedQuantity(position),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: QtyHistoryNoteInfo(
                      //         note: stockQuantityHistoryController
                      //             .stockHistoryList[position].reference,
                      //       ),
                      //     ),
                      //     QtyHistoryPriceInfo(
                      //       price: stockQuantityHistoryController
                      //           .stockHistoryList[position].currencyPrice,
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 14,
                      // ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: dividerColor,
                      ),
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
      );

  String getUpdatedQuantity(int position) {
    String result = "";
    if (!StringHelper.isEmptyString(
            stockQuantityHistoryController.stockHistoryList[position].qty) &&
        !StringHelper.isEmptyString(stockQuantityHistoryController
            .stockHistoryList[position].old_qty)) {
      int oldQty = int.parse(
          stockQuantityHistoryController.stockHistoryList[position].old_qty ??
              "0");
      int qty = int.parse(
          stockQuantityHistoryController.stockHistoryList[position].qty ?? "0");
      result += "(${oldQty + qty})";
    }
    return result;
  }
}
