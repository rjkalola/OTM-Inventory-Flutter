import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../../../res/drawable.dart';
import '../../controller/add_stock_product_controller.dart';

class QrCodeIconAddStockProduct extends StatelessWidget {
  QrCodeIconAddStockProduct({super.key});

  final addStockProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addStockProductController.openQrCodeScanner();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
              color: defaultAccentColor,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset(
              width: 24,
              height: 24,
              Drawable.barCodeIcon,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
