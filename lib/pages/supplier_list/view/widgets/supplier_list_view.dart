import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../controller/supplier_list_controller.dart';

class SupplierListView extends StatelessWidget {
  SupplierListView({super.key});

  final supplierListController = Get.put(SupplierListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: supplierListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                supplierListController.itemList.length,
                (position) => InkWell(
                  onTap: () {
                    supplierListController.addSupplierClick(supplierListController.itemList[position]);
                  },
                  child: CardView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleTextView(supplierListController
                              .itemList[position].contactName),
                          const SizedBox(
                            height: 2,
                          ),
                          itemTextView('email'.tr,
                              supplierListController.itemList[position].email),
                          itemTextView(
                              'phone'.tr,
                              supplierListController
                                  .itemList[position].phoneWithExtension),
                          itemTextView(
                              'company_name'.tr,
                              supplierListController
                                  .itemList[position].companyName),
                          itemTextView(
                              'address'.tr,
                              supplierListController
                                  .itemList[position].address),
                          itemTextView(
                              'weight'.tr,
                              supplierListController
                                  .itemList[position].supplierWeight),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget titleTextView(String? text) => Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Text(text ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            )),
      );

  Widget itemTextView(String title, String? text) => Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Text("$title: ${text ?? "-"}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: secondaryLightTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      );
}
