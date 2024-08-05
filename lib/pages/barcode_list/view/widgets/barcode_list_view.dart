import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/barcode_list/controller/barcode_list_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../res/colors.dart';

class BarcodeListView extends StatelessWidget {
  BarcodeListView({super.key});

  final barcodeListController = Get.put(BarcodeListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: barcodeListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                barcodeListController.barcodeList.length,
                (position) => InkWell(
                  onTap: () {
                    barcodeListController.showEditBarcodeDialog(
                        barcodeListController.barcodeList[position],
                        false,
                        position);
                  },
                  child: CardView(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                            child: PrimaryTextView(
                              text: barcodeListController.barcodeList[position],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
