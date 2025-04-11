import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/add_stock_product/controller/add_stock_product_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class AddPhotoView extends StatelessWidget {
  AddPhotoView({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addProductController.onSelectPhoto("");
      },
      child: Container(
        width: 116,
        height: 116,
        decoration: AppUtils.getGrayBorderDecoration(
          radius: 16,
          color: Color(
            AppUtils.haxColor("#f9f9fb"),
          ),
          borderColor: Color(
            AppUtils.haxColor("#d3d4d6"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              size: 26,
              weight: 300,
            ),
            const SizedBox(
              height: 6,
            ),
            PrimaryTextView(
              text: 'add_photo'.tr,
              fontSize: 15,
            )
          ],
        ),
      ),
    );
  }
}
