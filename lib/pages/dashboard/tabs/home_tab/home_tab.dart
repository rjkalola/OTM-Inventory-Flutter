import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/home_tab_action_buttons_dots_list.dart';
import 'package:otm_inventory/pages/dashboard/widgets/home_tab_action_buttons_list.dart';
import 'package:otm_inventory/pages/dashboard/widgets/home_tab_header_view.dart';
import 'package:otm_inventory/utils/app_utils.dart';

import '../../../../res/colors.dart';
import '../../models/DashboardActionItemInfo.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(child: Obx(() {
      return ModalProgressHUD(
        inAsyncCall: dashboardController.isLoading.value,
        child: Scaffold(
          backgroundColor: const Color(0xfff4f5f7),
          body: Column(children: [
            const HomeTabHeaderView(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                decoration: const BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: SingleChildScrollView(
                  child: Column(children: [
                    HomeTabActionButtonsList(),
                    // HomeTabActionButtonsDotsList(),
                  ]),
                ),
              ),
            )
          ]),
        ),
      );
    }));
  }

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
