import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_quantity_update_note.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/widgets/textfield_select_user.dart';

import '../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../stock_edit_quantity_controller.dart';

class RowReferenceUsers extends StatelessWidget {
  RowReferenceUsers({super.key});

  final stockEditQuantityController = Get.put(StockEditQuantityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(18, 9, 18, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Visibility(
                        visible: stockEditQuantityController
                            .isReferenceVisible.value,
                        child: TextFieldQuantityUpdateNote()),
                    Visibility(
                        visible: stockEditQuantityController
                            .isUserDropdownVisible.value,
                        child: TextFieldSelectUser()),
                    Visibility(
                      visible: stockEditQuantityController
                              .isReferenceVisible.value &&
                          stockEditQuantityController
                              .isClearReferenceVisible.value,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            stockEditQuantityController.noteController.value
                                .clear();
                            stockEditQuantityController
                                .isClearReferenceVisible.value = false;
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: stockEditQuantityController
                              .isUserDropdownVisible.value &&
                          stockEditQuantityController.isClearUserVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              stockEditQuantityController.clearUser();
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Stack(
                children: [
                  Visibility(
                    visible:
                        stockEditQuantityController.isUserDropdownVisible.value,
                    child: InkWell(
                      onTap: () {
                        stockEditQuantityController.isReferenceVisible.value =
                            true;
                        stockEditQuantityController
                            .isUserDropdownVisible.value = false;
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: rectangleBorderColor,
                              ),
                              borderRadius:
                                  BorderRadius.circular(4)), // grid items
                          width: 50,
                          height: 50,
                          child: Center(
                            child: SvgPicture.asset(
                              width: 24,
                              Drawable.descriptionIcon,
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible:
                        stockEditQuantityController.isReferenceVisible.value,
                    child: InkWell(
                      onTap: () {
                        stockEditQuantityController.isReferenceVisible.value =
                            false;
                        stockEditQuantityController
                            .isUserDropdownVisible.value = true;
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: rectangleBorderColor,
                              ),
                              borderRadius:
                                  BorderRadius.circular(4)), // grid items
                          width: 50,
                          height: 50,
                          child: Center(
                            child: SvgPicture.asset(
                              width: 24,
                              Drawable.personIcon,
                            ),
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
