import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/barcode_list/controller/barcode_list_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../res/colors.dart';
import '../../../../res/drawable.dart';

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
                (position) => CardView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                          child: PrimaryTextView(
                            text: barcodeListController.barcodeList[position],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          width: 26,
                          Drawable.editIcon,
                          colorFilter: const ColorFilter.mode(
                              primaryTextColor, BlendMode.srcIn),
                        ),
                        onPressed: () {
                          barcodeListController.showEditBarcodeDialog(
                              barcodeListController.barcodeList[position],
                              false,
                              position);
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          width: 26,
                          Drawable.deleteIcon,
                          colorFilter: const ColorFilter.mode(
                              primaryTextColor, BlendMode.srcIn),
                        ),
                        onPressed: () {
                          barcodeListController.deleteBarcodeDialog(position);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
