import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';
class TextFieldSelectStore extends StatelessWidget {
  TextFieldSelectStore({super.key});
  final stockListController = Get.put(StockListController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: TextFieldBorder(
          textEditingController: stockListController.storeNameController.value,
          hintText: 'select_store'.tr,
          labelText: 'store'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([

          ]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            stockListController.selectStore();
          }
      ),
    );
  }
}
