import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_filter/controller/stock_filter_controller.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../res/colors.dart';

class StockFilterCategoriesList extends StatelessWidget {
  StockFilterCategoriesList({super.key});

  final controller = Get.put(StockFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.categoriesList.length,
              (position) => InkWell(
                onTap: () {
                  // controller.onSelectCategory(position);

                 /* controller.applyFilter_(
                      controller.categoriesList[position].id != null
                          ? controller.categoriesList[position].id!
                          : 0,
                      controller.categoriesList[position].name != null
                          ? controller.categoriesList[position].name!
                          : "",
                      controller.categoriesList[position].key != null
                          ? controller.categoriesList[position].key!
                          : "");*/
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Row(
                        children: [
                          !StringHelper.isEmptyString(controller
                                  .categoriesList[position].thumb_image)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ImageUtils.setCachedNetworkImage(
                                      url: controller.categoriesList[position]
                                          .thumb_image!,
                                      width: 40,
                                      height: 40),
                                )
                              : Container(),
                          Expanded(
                            child: Text(
                                softWrap: true,
                                controller.categoriesList[position].name!,
                                style: const TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                          Checkbox(
                              activeColor: defaultAccentColor,
                              value:
                                  controller.categoriesList[position].check ??
                                      false,
                              onChanged: (isCheck) {
                                controller.categoriesList[position].check =
                                    isCheck;
                                controller.categoriesList.refresh();
                                controller
                                    .filterData.value.info![
                                        controller.selectedSupplierIndex.value]
                                    .data![position]
                                    .check = isCheck;
                              })
                          // SvgPicture.asset(
                          //   width: 22,
                          //   Drawable.checkIcon,
                          //   colorFilter: ColorFilter.mode(
                          //       controller.categoriesList[position].check ?? false
                          //           ? defaultAccentColor
                          //           : disableComponentColor,
                          //       BlendMode.srcIn),
                          // )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: Divider(
                        color: dividerColor,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
