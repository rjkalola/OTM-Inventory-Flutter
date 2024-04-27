import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class AddStockProductPhotosTitleView extends StatelessWidget {
  const AddStockProductPhotosTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 3, 14, 0),
      child: Text(
        'photos'.tr,
        style: const TextStyle(color: primaryTextColor, fontSize: 16),
      ),
    );
  }
}
