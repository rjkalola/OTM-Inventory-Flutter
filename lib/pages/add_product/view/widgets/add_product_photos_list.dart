import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../controller/add_product_controller.dart';

class AddProductPhotosList extends StatelessWidget {
  AddProductPhotosList({super.key});

  final addProductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (1 / 1),
          crossAxisCount: 4, // number of items in each row
          mainAxisSpacing: 7.0, // spacing between rows
          crossAxisSpacing: 7.0, // spacing between columns
        ),
        padding: const EdgeInsets.all(8.0),
        // padding around the grid
        itemCount: addProductController.filesList.length,
        // total number of items
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              addProductController.onSelectPhoto();
            },
            child: Container(
              // color of
              decoration: BoxDecoration(
                border: Border.all(
                  color: rectangleBorderColor,
                ),
              ), // grid items
              child: Stack(
                fit: StackFit.expand,
                children: [
                  !StringHelper.isEmptyString(
                          addProductController.filesList[index].file)
                      ? Image.network(
                          addProductController.filesList[index].file ?? "",
                          fit: BoxFit.cover)
                      : const Center(
                          child: Icon(
                          Icons.add,
                          size: 30,
                        )),
                  Visibility(
                    visible: !StringHelper.isEmptyString(
                        addProductController.filesList[index].file),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
