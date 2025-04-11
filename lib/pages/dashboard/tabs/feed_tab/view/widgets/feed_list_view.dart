import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class FeedListView extends StatelessWidget {
  FeedListView({super.key});

  final controller = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isMainViewVisible.value,
          child: Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return InkWell(
                  onTap: () {
                    Get.offNamed(AppRoutes.orderListScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageUtils.setUserImage(
                            controller.itemList[position].image ?? "",
                            50,
                            50,
                            50),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: (controller.itemList[position].message ??
                                        "")
                                    .replaceAll("\n", "<br>"),
                                style: {
                                  "body": Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(15),
                                      color: primaryTextColor),
                                },
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              PrimaryTextView(
                                text:
                                    controller.itemList[position].createdDate ??
                                        "",
                                fontSize: 13,
                                color: secondaryLightTextColor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.itemList.length,
              separatorBuilder: (context, position) => const Padding(
                padding: EdgeInsets.only(left: 72),
                child: Divider(
                  height: 0,
                  color: dividerColor,
                  thickness: 0.8,
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
