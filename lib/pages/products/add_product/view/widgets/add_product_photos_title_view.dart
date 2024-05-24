import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class AddProductPhotosTitleView extends StatelessWidget {
  const AddProductPhotosTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Text(
        'photos'.tr,
        style: const TextStyle(color: primaryTextColor, fontSize: 16),
      ),
    );
  }
}
