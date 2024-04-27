import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/drawable.dart';
import '../stock_list_controller.dart';
class QrCodeIcon extends StatelessWidget {
  QrCodeIcon({super.key});
  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: InkWell(
        onTap: (){
          stockListController.openQrCodeScanner();
        },
        child: SvgPicture.asset(
          width: 30,
          Drawable.qrCodeIcon,
        ),
      ),
    );
  }
}
