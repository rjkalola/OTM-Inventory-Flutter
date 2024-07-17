import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/controller/purchase_order_details_controller.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/view/widgets/product_item.dart';

class ProductItemsList extends StatelessWidget {
  ProductItemsList({super.key});

  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !controller.switchScanItem.value,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.orderProductList.length,
              (position) => ProductItem(
                info: controller.orderProductList[position],
                controller: controller.productItemsQty[position],
                onValueChange: (value) {
                  print("Position:" + position.toString());
                  print("value:" + value);
                  // controller.productItemsQty[position].text = "4";
                },
              ),
            ),
          ),
        ));
  }
}
