import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/category_list/category_list_controller.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../../../res/colors.dart';

class SearchCategory extends StatefulWidget {
  const SearchCategory({super.key});

  @override
  State<SearchCategory> createState() => _SearchCategoryState();
}

class _SearchCategoryState extends State<SearchCategory> {
  CategoryListController categoryListController = CategoryListController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: SearchTextField(
          onValueChange: (value) {
            categoryListController.searchItem(value.toString());
            // setModalState(() {
            //   filterSearchResults(value, list);
            // });
          }),
    );
  }
}
