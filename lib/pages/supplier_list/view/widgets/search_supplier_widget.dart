import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/pages/supplier_list/controller/supplier_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

import '../../../../res/colors.dart';

class SearchSupplierWidget extends StatefulWidget {
  const SearchSupplierWidget({super.key});

  @override
  State<SearchSupplierWidget> createState() => _SearchSupplierWidgetState();
}

class _SearchSupplierWidgetState extends State<SearchSupplierWidget> {
  SupplierListController supplierListController = SupplierListController();

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
