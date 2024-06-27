import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/pages/supplier_list/controller/supplier_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../../../res/colors.dart';
import '../../../../utils/string_helper.dart';

class SearchSupplierWidget extends StatefulWidget {
  const SearchSupplierWidget({super.key});

  @override
  State<SearchSupplierWidget> createState() => _SearchSupplierWidgetState();
}

class _SearchSupplierWidgetState extends State<SearchSupplierWidget> {
  final supplierListController = Get.put(SupplierListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: supplierListController.searchController,
          isClearVisible: supplierListController.isClearVisible,
          onValueChange: (value) {
            supplierListController.searchItem(value);
            supplierListController.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            supplierListController.searchController.value.clear();
            supplierListController.searchItem("");
            supplierListController.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
