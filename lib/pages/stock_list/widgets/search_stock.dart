import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../utils/string_helper.dart';

class SearchStockWidget extends StatefulWidget {
  const SearchStockWidget({super.key});

  @override
  State<SearchStockWidget> createState() => _SearchStockWidgetWidgetState();
}

class _SearchStockWidgetWidgetState extends State<SearchStockWidget> {
  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: stockListController.searchController,
          isClearVisible: stockListController.isClearVisible,
          onValueChange: (value) {
            stockListController.searchItem(value.toString());
            stockListController.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            stockListController.searchController.value.clear();
            stockListController.searchItem("");
            stockListController.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
