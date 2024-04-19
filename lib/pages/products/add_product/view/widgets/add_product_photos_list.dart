import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/gridview/image_gridview.dart';

import '../../controller/add_product_controller.dart';

class AddProductPhotosList extends StatelessWidget {
  AddProductPhotosList({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: ImageGridview(
            filesList: addProductController.filesList,
            onViewClick: () {
              addProductController.onSelectPhoto();
            },
            onRemoveClick: (int index) {
              addProductController.removePhotoFromList(index);
            }));
  }
}
