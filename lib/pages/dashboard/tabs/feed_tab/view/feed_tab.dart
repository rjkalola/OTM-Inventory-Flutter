import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/view/widgets/feed_list_empty_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/view/widgets/feed_list_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/view/widgets/search_feed_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/more_tab_buttons.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';

class FeedTab extends StatefulWidget {
  FeedTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeedTabState();
  }
}

class FeedTabState extends State<FeedTab> implements DialogButtonClickListener {
  final controller = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   surfaceTintColor: Colors.transparent,
      //   leadingWidth: 32, // <-- Use this- and this
      //   title: Text('more'.tr,
      //       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      // ),
      body: Obx(() => Column(children: [
        const Divider(
          thickness: 1,
          height: 1,
          color: dividerColor,
        ),
        // Visibility(
        //     visible: controller.itemList.isNotEmpty,
        //     child: const SearchFeedWidget()),
        controller.itemList.isNotEmpty ? FeedListView() : FeedListEmptyView(),
        const SizedBox(
          height: 12,
        ),
      ]),),
    );
  }

  Widget divider() => const Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child: Divider(thickness: 0.4, height: 0.4, color: dividerColor),
      );

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Get.back();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {}
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
