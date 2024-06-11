import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
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
                (position) => InkWell(
                  onTap: () {
                    storeListController
                        .addStoreClick(storeListController.storeList[position]);
                  },
                  child: CardView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleTextView(storeListController
                                  .storeList[position].storeName),
                              InkWell(
                                  onTap: () {
                                    AppStorage.storeId = storeListController
                                        .storeList[position].id!;
                                    AppStorage.storeName = storeListController
                                        .storeList[position].storeName!;

                                    Get.find<AppStorage>()
                                        .setStoreId(AppStorage.storeId);
                                    Get.find<AppStorage>()
                                        .setStoreName(AppStorage.storeName);

                                    storeListController.activeStoreId.value =
                                        AppStorage.storeId;
                                    AppUtils.showSnackBarMessage(
                                        "${storeListController.storeList[position].storeName} Activated");
                                  },
                                  child:
                                      const Icon(Icons.remove_red_eye_outlined))
                            ],
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          // itemTextView(
                          //     'phone'.tr,
                          //     storeListController
                          //         .storeList[position].phoneWithExtension),
                          Row(children: [
                            Expanded(
                              child: itemTextView(
                                  'address'.tr,
                                  storeListController
                                      .storeList[position].address),
                            ),
                            Visibility(
                              visible:
                                  storeListController.storeList[position].id! ==
                                      storeListController.activeStoreId.value,
                              child: Text('active'.tr,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  )),
                            )
                          ]),
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
              fontSize: 17,
            )),
      );

  Widget itemTextView(String title, String? text) => Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Text("$title: ${text ?? "-"}",
            softWrap: true,
            style: const TextStyle(
              color: secondaryLightTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      );
}
