import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../../../utils/string_helper.dart';
import '../../controller/purchase_order_list_controller.dart';

class SearchPurchaseOrderWidget extends StatefulWidget {
  const SearchPurchaseOrderWidget({super.key});

  @override
  State<SearchPurchaseOrderWidget> createState() => _SearchPurchaseOrderWidgetState();
}

class _SearchPurchaseOrderWidgetState extends State<SearchPurchaseOrderWidget> {
  final controller = Get.put(PurchaseOrderListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          onValueChange: (value) {
            controller.searchItem(value.toString());
            controller.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            controller.searchController.value.clear();
            controller.searchItem("");
            controller.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
