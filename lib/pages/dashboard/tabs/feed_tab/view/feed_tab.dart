import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/widgets/load_more_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/controller/feed_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/view/widgets/feed_list_empty_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/view/widgets/feed_list_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';

class FeedTab extends StatefulWidget {
  FeedTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeedTabState();
  }
}

class FeedTabState extends State<FeedTab>
    with AutomaticKeepAliveClientMixin
    implements DialogButtonClickListener {
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
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.getFeedList(true, true);
            },
            child: Column(children: [
              const Divider(
                thickness: 1,
                height: 1,
                color: dividerColor,
              ),
              // Visibility(
              //     visible: controller.itemList.isNotEmpty,
              //     child: const SearchFeedWidget()),
              controller.itemList.isNotEmpty
                  ? FeedListView()
                  : FeedListEmptyView(),
              const SizedBox(
                height: 8,
              ),
              Visibility(
                visible: controller.isLoadMore.value,
                child: const LoadMoreView(),
              ),
            ]),
          ),
        ),
      ),
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

  @override
  bool get wantKeepAlive => true;
}
