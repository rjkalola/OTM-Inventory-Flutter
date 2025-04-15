import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
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
                    if (AppUtils.isPermission(
                        AppStorage().getPermissions().updateSupplier)) {
                      supplierListController.addSupplierClick(
                          supplierListController.itemList[position]);
                    }
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
                            height: 4,
                          ),
                          itemTextView(
                              'email'.tr,
                              supplierListController.itemList[position].email,
                              Drawable.emailIcon,
                              true),
                          itemTextView(
                              'phone'.tr,
                              supplierListController
                                  .itemList[position].phoneWithExtension,
                              Drawable.phoneCallIcon,
                              true),
                          itemTextView(
                              'company_name'.tr,
                              supplierListController
                                  .itemList[position].companyName,
                              "",
                              false),
                          itemTextView(
                              'address'.tr,
                              supplierListController
                                  .itemList[position].location,
                              "",
                              false),
                          itemTextView(
                              'weight'.tr,
                              supplierListController
                                  .itemList[position].supplierWeight,
                              "",
                              false),
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
              fontWeight: FontWeight.w600,
              fontSize: 18,
            )),
      );

  Widget itemTextView(
          String title, String? text, String iconPath, bool isIconVisible) =>
      Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Row(
            children: [
              isIconVisible
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ImageUtils.setAssetsImage(
                          path: iconPath,
                          width: 18,
                          height: 18,
                          color: defaultAccentColor),
                    )
                  : Container(),
              Text("$title: ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  )),
              Text(text ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        isIconVisible ? defaultAccentColor : primaryTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ))
            ],
          ),
        ),
      );
}
