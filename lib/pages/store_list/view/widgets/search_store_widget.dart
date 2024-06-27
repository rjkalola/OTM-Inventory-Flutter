import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../../utils/string_helper.dart';

class SearchStoreWidget extends StatefulWidget {
  const SearchStoreWidget({super.key});

  @override
  State<SearchStoreWidget> createState() => _SearchStoreWidgetState();
}

class _SearchStoreWidgetState extends State<SearchStoreWidget> {
  final storeListController = Get.put(StoreListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: storeListController.searchController,
          isClearVisible: storeListController.isClearVisible,
          onValueChange: (value) {
            storeListController.searchItem(value.toString());
            storeListController.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            storeListController.searchController.value.clear();
            storeListController.searchItem("");
            storeListController.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
