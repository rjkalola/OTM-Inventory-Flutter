import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../res/drawable.dart';
import '../../../utils/string_helper.dart';
import '../stock_list_controller.dart';

class StockFilterClearIcon extends StatelessWidget {
  StockFilterClearIcon({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 9, 0, 9),
      child: InkWell(
        onTap: () {
          stockListController.getStockListApi(true, false, "", true, true);
        },
        child: Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
              color: !StringHelper.isEmptyString(Get.put(StockListController())
                  .mSupplierCategoryFilter
                  .value)
                  ? backgroundColor
                  : disableComponentColor,
              border: Border.all(color: rectangleBorderColor),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              width: 24,
              height: 24,
              Drawable.closeIcon,
              colorFilter: ColorFilter.mode(
                  !StringHelper.isEmptyString(Get.put(StockListController())
                      .mSupplierCategoryFilter
                      .value)
                      ? Colors.black
                      : Colors.black54,
                  BlendMode.srcIn),            ),
          ),
        ),
      ),
    );
  }
}
