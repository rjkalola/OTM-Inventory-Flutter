import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/add_category/add_category_controller.dart';
import 'package:otm_inventory/widgets/image/grid_image.dart';
import 'package:get/get.dart';

class ImageSelectIcon extends StatelessWidget {
  ImageSelectIcon({super.key});

  final addCategoryController = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        width: 90,
        height: 90,
        child: GestureDetector(
          onTap: (){
            addCategoryController.onClickAddPhoto();
          },
          child: GridImage(
            file: addCategoryController.filePath.value,
            fileRadius: 16,
            onRemoveClick: () {
              addCategoryController.onClickRemoveIcon();
            },
          ),
        ),
      ),
    );
  }
}
