import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SearchTextField(
          onValueChange: (value) {
            stockListController.searchItem(value.toString());
            // setModalState(() {
            //   filterSearchResults(value, list);
            // });
          }),
    );
  }
}
