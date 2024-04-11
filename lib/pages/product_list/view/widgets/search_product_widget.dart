import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/product_list/controller/product_list_controller.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/pages/supplier_list/controller/supplier_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../../../res/colors.dart';

class SearchProductWidget extends StatefulWidget {
  const SearchProductWidget({super.key});

  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  ProductListController productListController = ProductListController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SearchTextField(
          onValueChange: (value) {
            // setModalState(() {
            //   filterSearchResults(value, list);
            // });
          }),
    );
  }
}
