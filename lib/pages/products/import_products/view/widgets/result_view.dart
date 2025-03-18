import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class ResultView extends StatelessWidget {
  ResultView({super.key});

  final controller = Get.put(ImportProductsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isResultVisible.value
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
                    child: PrimaryTextView(
                      text: controller.resultMessage.value ?? "",
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
              ),
            )
          : Container(),
    );
  }
}
