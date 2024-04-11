import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../../../res/colors.dart';

class SearchStoreWidget extends StatefulWidget {
  const SearchStoreWidget({super.key});

  @override
  State<SearchStoreWidget> createState() => _SearchStoreWidgetState();
}

class _SearchStoreWidgetState extends State<SearchStoreWidget> {
  StoreListController storeListController = StoreListController();

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
