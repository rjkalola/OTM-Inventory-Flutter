import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/home_tab_action_buttons_list.dart';
import 'package:otm_inventory/pages/dashboard/widgets/home_tab_header_view.dart';
import 'package:otm_inventory/pages/dashboard/widgets/textfield_select_store.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_storage.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../widgets/home_tab_action_buttons_dots_list.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = Get.put(DashboardController());
  late var userInfo = UserInfo();

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    userInfo = Get.find<AppStorage>().getUserInfo();

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
        opacity: 0,
        progressIndicator: const CustomProgressbar(),
        child: Scaffold(
          backgroundColor: const Color(0xfff4f5f7),
          body: Visibility(
            visible: dashboardController.isMainViewVisible.value,
            child: Column(children: [
              HomeTabHeaderView(
                userName: userInfo.firstName ?? "",
                userImage: userInfo.image ?? "",
              ),
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
                      const SizedBox(height:20,),
                      TextFieldSelectStoreHomeTab(),
                      HomeTabActionButtonsList(),
                      HomeTabActionButtonsDotsList(),
                    ]),
                  ),
                ),
              )
            ]),
          ),
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
