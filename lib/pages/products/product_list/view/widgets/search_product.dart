import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../controller/product_list_controller.dart';

class SearchProductWidget extends StatefulWidget {
  const SearchProductWidget({super.key});

  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  final productListController = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: productListController.searchController.value,
          onValueChange: (value) {
            productListController.searchItem(value.toString());
            // setModalState(() {
            //   filterSearchResults(value, list);
            // });
          },
          onPressedClear: () {
            productListController.searchController.value.clear();
            productListController.searchItem("");
          },
        ),
      ),
    );
  }
}
