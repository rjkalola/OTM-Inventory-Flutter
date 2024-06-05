import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../res/drawable.dart';
import '../../../utils/string_helper.dart';
import '../stock_list_controller.dart';

class StockFilterIcon extends StatelessWidget {
  StockFilterIcon({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 9, 0, 9),
      child: InkWell(
        onTap: () {
          if (!StringHelper.isEmptyString(
              Get.put(StockListController()).mSupplierCategoryFilter.value)) {
            stockListController.getStockListApi(true, false, "", true, true);
          } else {
            stockListController.stockFilter();
          }
        },
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              // color: !StringHelper.isEmptyString(Get.put(StockListController())
              //         .mSupplierCategoryFilter
              //         .value)
              //     ? backgroundColor
              //     : defaultAccentColor,color: !StringHelper.isEmptyString(Get.put(StockListController())
              //         .mSupplierCategoryFilter
              //         .value)
              //     ? backgroundColor
              //     : defaultAccentColor,
              border: Border.all(
                  color: !StringHelper.isEmptyString(
                          Get.put(StockListController())
                              .mSupplierCategoryFilter
                              .value)
                      ? rectangleBorderColor
                      : defaultAccentColor),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              width: 24,
              height: 24,
              !StringHelper.isEmptyString(Get.put(StockListController())
                      .mSupplierCategoryFilter
                      .value)
                  ? Drawable.closeIcon
                  : Drawable.filterIcon,
              colorFilter: ColorFilter.mode(
                  !StringHelper.isEmptyString(Get.put(StockListController())
                          .mSupplierCategoryFilter
                          .value)
                      ? Colors.black
                      : defaultAccentColor,
                  BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
