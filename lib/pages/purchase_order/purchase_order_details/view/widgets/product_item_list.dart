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
              3,
              (position) => ProductItem(
                controller: controller.productItemsQty[position],
              ),
            ),
          ),
        ));
  }
}
