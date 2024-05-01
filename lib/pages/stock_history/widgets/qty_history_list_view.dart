import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_history/widgets/note_info.dart';
import 'package:otm_inventory/pages/stock_history/widgets/user_info.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import '../../../../res/colors.dart';
import '../../../utils/image_utils.dart';
import '../stock_quantity_history_controller.dart';

class QtyHistoryListView extends StatelessWidget {
  QtyHistoryListView({super.key});

  final stockQuantityHistoryController =
      Get.put(StockQuantityHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: stockQuantityHistoryController
              .stockHistoryList.isNotEmpty,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                stockQuantityHistoryController
                    .stockHistoryList.length,
                (position) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextView(
                                stockQuantityHistoryController
                                    .stockHistoryList
                                   [position]
                                    .created_at_formatted,
                                16,
                                FontWeight.w400,
                                primaryTextColorLight,
                                const EdgeInsets.all(0)),
                            customTextView(
                                stockQuantityHistoryController
                                    .stockHistoryList[position]
                                    .qty,
                                16,
                                FontWeight.w400,
                                (int.parse(stockQuantityHistoryController
                                    .stockHistoryList[position]
                                            .qty!) >
                                        0)
                                    ? Colors.green
                                    : Colors.red,
                                const EdgeInsets.all(0)),
                          ],
                        ),
                      ),
                      QtyHistoryUserInfo(user: stockQuantityHistoryController
                          .stockHistoryList[position]
                            .user,),
                      QtyHistoryNoteInfo(note: stockQuantityHistoryController
                          .stockHistoryList[position].reference,),
                      const SizedBox(height: 14,),
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
}
