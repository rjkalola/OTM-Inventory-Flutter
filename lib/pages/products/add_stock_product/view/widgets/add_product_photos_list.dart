import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/gridview/image_gridview.dart';

import '../../controller/add_stock_product_controller.dart';

class AddStockProductPhotosList extends StatelessWidget {
  AddStockProductPhotosList({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: ImageGridview(
            physics: const NeverScrollableScrollPhysics(),
            filesList: addProductController.filesList,
            onViewClick: (int index) {
              addProductController.onSelectPhoto(index);
            },
            onRemoveClick: (int index) {
              addProductController.removePhotoFromList(index);
            }));
  }
}
