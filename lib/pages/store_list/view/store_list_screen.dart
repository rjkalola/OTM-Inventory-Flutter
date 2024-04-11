import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/store_list/controller/store_list_controller.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/search_store_widget.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/store_list_empty_view.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/store_list_view.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final storeListController = Get.put(StoreListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'stores'.tr,
          isBack: true,
          widgets: actionButtons()),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: storeListController.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: Column(children: [
            const Divider(
              thickness: 1,
              height: 1,
              color: dividerColor,
            ),
            Visibility(
                visible: storeListController.storeList.isNotEmpty,
                child: const SearchStoreWidget()),
            storeListController.storeList.isNotEmpty
                ? StoreListView()
                : StoreListEmptyView(),
            const SizedBox(
              height: 12,
            ),
          ]),
        ),
      ),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: storeListController.productList.isNotEmpty,
      //   child: IconButton(
      //     icon: SvgPicture.asset(
      //       width: 22,
      //       Drawable.searchIcon,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // IconButton(
      //   icon: SvgPicture.asset(
      //     width: 22,
      //     Drawable.filterIcon,
      //   ),
      //   onPressed: () {},
      // ),
      // IconButton(
      //   icon: const Icon(Icons.add, size: 24,color: primaryTextColor),
      //   onPressed: () {
      //     storeListController.addProductClick();
      //   },
      // ),
    ];
  }
}
