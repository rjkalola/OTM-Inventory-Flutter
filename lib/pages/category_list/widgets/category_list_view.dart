import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/category_list/category_list_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import '../../../../res/colors.dart';

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
                    categoryListController.addCategoryClick(
                        categoryListController.categoryList[position]);
                  },
                  child: CardView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleTextView(categoryListController
                              .categoryList[position].name??""),
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
    child: Text(
        text??"",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        )),
  );

  Widget itemTextView(String title,
      String? text) => Visibility(
    visible: !StringHelper.isEmptyString(text),
    child: Text(
        "$title: ${text??"-"}",
        style: const TextStyle(
          color: secondaryLightTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        )),
  );
}
