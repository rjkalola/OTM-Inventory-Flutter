import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class UploadFileView extends StatelessWidget {
  UploadFileView({super.key});

  final controller = Get.put(ImportProductsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isUploadViewVisible.value
          ? SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: CardView(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                  child: InkWell(
                    onTap: () {
                      controller.pickFile();
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          width: 40,
                          Drawable.uploadIcon,
                          colorFilter: const ColorFilter.mode(
                              primaryTextColor, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        PrimaryTextView(
                          text: 'upload_file'.tr,
                          color: secondaryLightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        PrimaryTextView(
                          text: 'csv_xl_xls'.tr,
                          color: secondaryLightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    ),
                  ),
                )),
              ),
            )
          : Container(),
    );
  }
}
