import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/add_stock_product/controller/add_stock_product_controller.dart';
import 'package:otm_inventory/widgets/text_field_border.dart';

class PackOffView extends StatelessWidget {
  PackOffView({super.key});

  final addProductController = Get.put(AddStockProductController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: TextFieldBorder(
                  isReadOnly: !addProductController.isPackOffEnable.value,
                  textEditingController:
                      addProductController.packOffController.value,
                  hintText: 'pack_off'.tr,
                  labelText: 'pack_off'.tr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onValueChange: (value) {
                    // if (value.contains(",") || value.contains(" ") || value.contains("-")) {
                    //   String newText = value.replaceAll(",", "").replaceAll("-", "").replaceAll(" ", "");
                    //   addProductController.packOffController.value.text = newText;
                    // }
                    addProductController.onValueChange();
                  },
                  validator: MultiValidator([
                    // CustomFieldValidator((value) {
                    //   return value != null &&
                    //       !addProductController.isPackOffEnable.value;
                    // }, errorText: 'required'.tr),
                  ]),
                  onPressed: () {}),
            ),
            const SizedBox(
              width: 14,
            ),
            Flexible(
              flex: 7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TextFieldBorder(
                      isReadOnly: !addProductController.isPackOffEnable.value,
                      textEditingController:
                          addProductController.packOffUnitController.value,
                      hintText: 'select_unit_or_add'.tr,
                      labelText: 'select_unit_or_add'.tr,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onValueChange: (value) {
                        addProductController.onPackOfUnitValueChange();
                      },
                      validator: MultiValidator([
                        // CustomFieldValidator((value) {
                        //   return !addProductController.isPackOffEnable.value &&
                        //       value != null;
                        // }, errorText: 'required'.tr),
                        // CustomFieldValidator((value) {
                        //   return addProductController.isPackOffEnable.value &&
                        //       value == null;
                        // }, errorText: 'required'.tr),
                      ]),
                      onPressed: () {}),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          addProductController.showPackOffUnitList();
                        },
                        child: const SizedBox(
                            width: 40,
                            height: 30,
                            child: Icon(Icons.arrow_drop_down_outlined)),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
