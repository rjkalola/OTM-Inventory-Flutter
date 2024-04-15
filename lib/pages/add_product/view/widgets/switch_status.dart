import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/colors.dart';
import '../../controller/add_product_controller.dart';
class SwitchStatus extends StatelessWidget {
  SwitchStatus({super.key});
  final addProductController = Get.put(AddProductController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14,bottom: 18),
      child: Row(
        children: [
          Text('status'.tr,style: const TextStyle(fontSize: 16,color: primaryTextColor),),
          const SizedBox(width: 4,),
          Switch(
              value: addProductController.isStatus.value,
              activeColor: defaultAccentColor,
              onChanged: (isVisible) {
                addProductController.isStatus.value =
                    isVisible;
              })
        ],
      ),
    );
  }
}
