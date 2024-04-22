import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';

import '../image/grid_image.dart';

class ImageGridview extends StatelessWidget {
  const ImageGridview(
      {super.key,
      required this.filesList,
      required this.onViewClick,
      required this.onRemoveClick});

  final List<FileInfo> filesList;
  final VoidCallback onViewClick;
  final ValueChanged<int> onRemoveClick;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
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
      itemCount: filesList.length,
      // total number of items
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            onViewClick();
          },
          child: GridImage(
            file: filesList[index].file ?? "", onRemoveClick: (){
            onRemoveClick(index);
          },),
        );
      },
    ));
  }

}

class CloseClick {
  final ValueChanged<int> callback;

  CloseClick(this.callback);
}