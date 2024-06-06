import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';
import '../../controller/product_list_controller.dart';

class ProductListEmptyView extends StatelessWidget {
  ProductListEmptyView({super.key});

  final productListController = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: productListController.isMainViewVisible.value,
          child: Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('empty_data_message'.tr,
                    style: const TextStyle(
                        fontSize: 16, color: secondaryTextColor)),
                const SizedBox(height: 12,),
                PrimaryBorderButton(
                  buttonText: 'reload'.tr,
                  textColor: defaultAccentColor,
                  borderColor: defaultAccentColor,
                  height: 30,
                  fontSize: 14,
                  onPressed: () {
                    // productListController.getProductListApi(true, "0",true);
                  },
                )
              ],
            ),
          )),
        ));
  }
}
