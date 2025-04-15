import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import '../../../utils/app_storage.dart';
import '../../../utils/app_utils.dart';
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
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'suppliers'.tr,
              isCenterTitle: false,
              isBack: true,
              widgets: actionButtons()),
          drawerScrimColor: Colors.transparent,
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
                    visible: supplierListController.isMainViewVisible.value,
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
        )),
      ),
    );
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
      Visibility(
        visible:
            AppUtils.isPermission(AppStorage().getPermissions().addSupplier),
        child: IconButton(
          icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
          onPressed: () {
            supplierListController.addSupplierClick(null);
          },
        ),
      ),
      // ),
    ];
  }

  Future<bool> onBackPress() {
    DateTime now = DateTime.now();
    if (mTime == null || now.difference(mTime) > const Duration(seconds: 2)) {
      mTime = now;
      AppUtils.showSnackBarMessage('exit_warning'.tr);
      return Future.value(false);
    }

    return Future.value(true);
  }
}
