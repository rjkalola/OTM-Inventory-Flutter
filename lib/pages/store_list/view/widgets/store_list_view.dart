import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../controller/store_list_controller.dart';

class StoreListView extends StatelessWidget {
  StoreListView({super.key});

  final storeListController = Get.put(StoreListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: storeListController.isMainViewVisible.value,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                storeListController.storeList.length,
                (position) => CardView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleTextView(storeListController
                            .storeList[position].storeName),
                        const SizedBox(
                          height: 2,
                        ),
                        itemTextView('phone'.tr, storeListController.storeList[position].phoneWithExtension),
                        itemTextView('address'.tr, storeListController.storeList[position].address),
                      ],
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: secondaryLightTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        )),
  );
}
