import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/drawable.dart';
import '../stock_edit_quantity_controller.dart';

class QrCodeIconEditStock extends StatelessWidget {
  QrCodeIconEditStock({super.key});
  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: InkWell(
        onTap: (){
          stockEditQuantityController.onClickQrCode();
        },
        child: SvgPicture.asset(
          width: 30,
          Drawable.qrCodeIcon,
        ),
      ),
    );
  }
}
