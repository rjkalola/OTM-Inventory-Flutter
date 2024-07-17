import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../controller/purchase_order_details_controller.dart';

class SupplierName extends StatelessWidget {
   SupplierName({super.key});
  final controller = Get.put(PurchaseOrderDetailsController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: PrimaryTextView(
        text: controller.info?.supplierName ?? "",
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
