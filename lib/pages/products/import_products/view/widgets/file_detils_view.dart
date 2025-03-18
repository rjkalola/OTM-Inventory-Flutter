import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class FileDetailsView extends StatelessWidget {
  FileDetailsView({super.key});

  final controller = Get.put(ImportProductsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isFileDetailsVisible.value
          ? SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: CardView(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.pickFile();
                        },
                        child: SvgPicture.asset(
                          width: 60,
                          Drawable.csvFileIcon,
                          colorFilter: const ColorFilter.mode(
                              primaryTextColor, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryTextView(
                        softWrap: true,
                        textAlign: TextAlign.center,
                        text: controller.fileName.value ?? "",
                        color: secondaryLightTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: "addRecord",
                            groupValue: controller.selectedOption.value,
                            onChanged: (value) {
                              controller.selectedOption.value = value ?? "";
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          InkWell(
                              onTap: () {
                                controller.selectedOption.value = "addRecord";
                              },
                              child: PrimaryTextView(
                                text: 'add_new_products'.tr,
                                fontSize: 15,
                                color: primaryTextColor,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: "editRecord",
                            groupValue: controller.selectedOption.value,
                            onChanged: (value) {
                              controller.selectedOption.value = value ?? "";
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          InkWell(
                              onTap: () {
                                controller.selectedOption.value = "editRecord";
                              },
                              child: PrimaryTextView(
                                text: 'edit_existing_products'.tr,
                                fontSize: 15,
                                color: primaryTextColor,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: "addEditRecord",
                            groupValue: controller.selectedOption.value,
                            onChanged: (value) {
                              controller.selectedOption.value = value ?? "";
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          InkWell(
                              onTap: () {
                                controller.selectedOption.value =
                                    "addEditRecord";
                              },
                              child: PrimaryTextView(
                                text: 'add_and_edit_products'.tr,
                                fontSize: 15,
                                color: primaryTextColor,
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            )
          : Container(),
    );
  }
}
