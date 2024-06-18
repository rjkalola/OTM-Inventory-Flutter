import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';
import '../../controller/add_stock_product_controller.dart';

class TextFieldStockProductCategory extends StatelessWidget {
  TextFieldStockProductCategory({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController:
              addProductController.productCategoryController.value,
          hintText: 'category'.tr,
          labelText: 'category'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            addProductController.showCategoryList();
          }),
    );
  }
}
