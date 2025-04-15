import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/category_list/category_list_controller.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import '../../../../res/colors.dart';
import '../../../utils/app_storage.dart';
import '../../../utils/app_utils.dart';

class CategoryListView extends StatelessWidget {
  CategoryListView({super.key});

  final categoryListController = Get.put(CategoryListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: categoryListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                categoryListController.categoryList.length,
                (position) => InkWell(
                  onTap: () {
                    if (AppUtils.isPermission(
                        AppStorage().getPermissions().updateProductCategory)) {
                      categoryListController.addCategoryClick(
                          categoryListController.categoryList[position]);
                    }
                  },
                  child: CardView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageUtils.setCachedNetworkImage(
                              url: categoryListController
                                      .categoryList[position].imageThumbUrl ??
                                  "",
                              width: 36,
                              height: 36),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryTextView(
                                  softWrap: true,
                                  text: categoryListController
                                          .categoryList[position].name ??
                                      "-",
                                  color: primaryTextColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                // const SizedBox(
                                //   height: 2,
                                // ),
                                // PrimaryTextView(
                                //   text: "16 Items",
                                //   color: secondaryLightTextColor,
                                //   fontSize: 14,
                                //   fontWeight: FontWeight.w400,
                                // )
                              ],
                            ),
                          ),
                          PrimaryButton(
                              buttonText: 'view'.tr,
                              borderRadius: 10,
                              fontSize: 16,
                              buttonHeight: 38,
                              fontWeight: FontWeight.w500,
                              buttonColor: const Color(0xfffbf8fc),
                              buttonTextColor: defaultAccentColor,
                              onPressed: () {
                                if (AppUtils.isPermission(AppStorage()
                                    .getPermissions()
                                    .updateProductCategory)) {
                                  categoryListController.addCategoryClick(
                                      categoryListController
                                          .categoryList[position]);
                                }
                              })
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
            style: const TextStyle(
              color: secondaryLightTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      );
}
