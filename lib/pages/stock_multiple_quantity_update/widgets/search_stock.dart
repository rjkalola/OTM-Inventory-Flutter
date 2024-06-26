import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

class SearchStockMultipleQuantityUpdateWidget extends StatefulWidget {
  const SearchStockMultipleQuantityUpdateWidget({super.key});

  @override
  State<SearchStockMultipleQuantityUpdateWidget> createState() => _SearchStockWidgetWidgetState();
}

class _SearchStockWidgetWidgetState extends State<SearchStockMultipleQuantityUpdateWidget> {
  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SearchTextField(
        controller: stockListController.searchController,
          onValueChange: (value) {
            stockListController.searchItem(value.toString());
            // setModalState(() {
            //   filterSearchResults(value, list);
            // });
          },onPressedClear: () {},),
    );
  }
}
