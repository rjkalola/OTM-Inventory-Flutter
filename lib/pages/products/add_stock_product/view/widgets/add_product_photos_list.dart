import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/gridview/image_gridview.dart';

import '../../controller/add_stock_product_controller.dart';

class AddStockProductPhotosList extends StatelessWidget {
  AddStockProductPhotosList({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: addProductController.filesList.isNotEmpty,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
            child: ImageGridview(
                physics: const NeverScrollableScrollPhysics(),
                filesList: addProductController.filesList,
                fileRadius: 12,
                onViewClick: (int index) {
                  addProductController.onSelectPhoto(
                      addProductController.filesList[index].file ?? "");
                },
                onRemoveClick: (int index) {
                  addProductController.removePhotoFromList(index);
                })),
      ),
    );
  }
}
