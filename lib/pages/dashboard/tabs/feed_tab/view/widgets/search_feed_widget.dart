import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';


class SearchFeedWidget extends StatefulWidget {
  const SearchFeedWidget({super.key});

  @override
  State<SearchFeedWidget> createState() => _SearchFeedWidgetState();
}

class _SearchFeedWidgetState extends State<SearchFeedWidget> {
  final controller = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: SizedBox(
        height: 40,
        child: SearchTextField(
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          onValueChange: (value) {
            controller.searchItem(value);
            controller.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            controller.searchController.value.clear();
            controller.searchItem("");
            controller.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
