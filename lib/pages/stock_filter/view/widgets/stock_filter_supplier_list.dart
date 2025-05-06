import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_filter/controller/stock_filter_controller.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_info.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../res/colors.dart';

class StockFilterSupplierList extends StatelessWidget {
  StockFilterSupplierList({super.key});

  final controller = Get.put(StockFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: titleBgColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.supplierList.length,
              (position) => InkWell(
                onTap: () {
                  controller.onSelectSupplier(position);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: controller.selectedSupplierIndex.value == position
                          ? backgroundColor
                          : titleBgColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                        child: Row(
                          children: [
                            !StringHelper.isEmptyString(controller
                                    .supplierList[position].thumb_image)
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ImageUtils.setCachedNetworkImage(
                                        url: controller.supplierList[position]
                                            .thumb_image!,
                                        width: 36,
                                        height: 36),
                                  )
                                : Container(),
                            Expanded(
                              child: Text(
                                  softWrap: true,
                                  controller.supplierList[position].name!,
                                  style: const TextStyle(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  )),
                            ),
                            Visibility(
                              visible: getSelectedItemCount(controller
                                      .filterData.value.info![position].data!,position) >
                                  0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: PrimaryTextView(
                                  text: getSelectedItemCount(controller
                                          .filterData
                                          .value
                                          .info![position]
                                          .data!,position)
                                      .toString(),
                                  fontSize: 14,
                                  color: primaryTextColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: dividerColor,
                      height: 0.5,
                      thickness: 0.5,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  int getSelectedItemCount(List<FilterInfo> listCategory, int index) {
    int count = 0;
    if (index != controller.selectedSupplierIndex.value) {
      for (var info in listCategory) {
        if (info.check ?? false) {
          count = count + 1;
        }
      }
    } else {
      for (var info in controller.categoriesList) {
        if (info.check ?? false) {
          count = count + 1;
        }
      }
    }

    return count;
  }
}
