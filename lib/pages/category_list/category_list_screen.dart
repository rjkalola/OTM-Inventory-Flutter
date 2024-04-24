import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/category_list/widgets/category_list_empty_view.dart';
import 'package:otm_inventory/pages/category_list/widgets/category_list_view.dart';
import 'package:otm_inventory/pages/category_list/widgets/search_category.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/search_store_widget.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/store_list_empty_view.dart';
import 'package:otm_inventory/pages/store_list/view/widgets/store_list_view.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../common/widgets/common_bottom_navigation_bar_widget.dart';
import '../dashboard/widgets/main_drawer.dart';
import 'category_list_controller.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final categoryListController = Get.put(CategoryListController());

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
          title: 'categories'.tr,
          isBack: true,
          widgets: actionButtons()),
      drawer: MainDrawer(),
      bottomNavigationBar: const CommonBottomNavigationBarWidget(),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: categoryListController.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: Column(children: [
            const Divider(
              thickness: 1,
              height: 1,
              color: dividerColor,
            ),
            Visibility(
                visible: categoryListController.categoryList.isNotEmpty,
                child: const SearchCategory()),
            categoryListController.categoryList.isNotEmpty
                ? CategoryListView()
                : CategoryListEmptyView(),
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
      IconButton(
        icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
        onPressed: () {
          categoryListController.addCategoryClick(null);
        },
      ),
    ];
  }
}
