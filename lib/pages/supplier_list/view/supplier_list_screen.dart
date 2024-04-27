import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/supplier_list/controller/supplier_list_controller.dart';
import 'package:otm_inventory/pages/supplier_list/view/widgets/search_supplier_widget.dart';
import 'package:otm_inventory/pages/supplier_list/view/widgets/supplier_list_empty_view.dart';
import 'package:otm_inventory/pages/supplier_list/view/widgets/supplier_list_view.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../common/widgets/common_bottom_navigation_bar_widget.dart';
import '../../dashboard/widgets/main_drawer.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final supplierListController = Get.put(SupplierListController());

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
              title: 'suppliers'.tr,
              isBack: true,
              widgets: actionButtons()),
          drawer: MainDrawer(),
          bottomNavigationBar: const CommonBottomNavigationBarWidget(),
          body: Obx(
                () => ModalProgressHUD(
              inAsyncCall: supplierListController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Column(children: [
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                Visibility(
                    visible: supplierListController.itemList.isNotEmpty,
                    child: const SearchSupplierWidget()),
                supplierListController.itemList.isNotEmpty
                    ? SupplierListView()
                    : SupplierListEmptyView(),
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
          supplierListController.addSupplierClick(null);
        },
      ),
      // ),
    ];
  }
}
