import 'package:flutter/material.dart';

class GridA4Size extends StatelessWidget {
  const GridA4Size({
    super.key,
  });

  // final List<FilesInfo> filesList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(
          3,
              (position) {
            return Container(
              child: Column(
                children: [
                  Image.network(
                    "https://cdn.pixabay.com/photo/2024/02/05/16/23/labrador-8554882_1280.jpg",
                  ),
                  Text("Product Title")
                ],
              ),
            );
          },
        ));
  }
}
