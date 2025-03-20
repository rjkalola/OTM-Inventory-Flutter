import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_product_item.dart';

class OrderProductItemsList extends StatelessWidget {
  OrderProductItemsList({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(
            controller.orderProductList.length,
            (position) => OrderProductItem(
              info: controller.orderProductList[position],
              position: position,
              totalLength: controller.orderProductList.length,
              controller: controller.productItemsQty[position],
              onValueChange: (value) {
                print("Position:" + position.toString());
                print("value:" + value);
                // controller.productItemsQty[position].text = "4";
              },
            ),
          ),
        ));
  }
}
