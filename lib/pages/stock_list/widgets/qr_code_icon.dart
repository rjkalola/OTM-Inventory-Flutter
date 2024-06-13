import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../res/drawable.dart';
import '../stock_list_controller.dart';

class QrCodeIcon extends StatelessWidget {
  QrCodeIcon({super.key});

  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 9, 12, 9),
      child: InkWell(
        onTap: () {
          stockListController.openQrCodeScanner();
        },
        child: Container(
          width: 90,
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
