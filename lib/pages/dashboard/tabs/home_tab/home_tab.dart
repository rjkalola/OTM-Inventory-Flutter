import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/dashboard_stock_count_item.dart';
import 'package:otm_inventory/pages/dashboard/widgets/textfield_select_store.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_storage.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/PrimaryBorderButton.dart';
import '../../../../widgets/text/PrimaryTextView.dart';
import '../../widgets/home_tab_header_buttons_list.dart';

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
          // backgroundColor: const Color(0xfff4f5f7),
          body: Visibility(
            visible: dashboardController.isMainViewVisible.value,
            child: Column(children: [
              const Divider(
                thickness: 1,
                height: 1,
                color: dividerColor,
              ),
              // HomeTabHeaderView(
              //   userName: userInfo.firstName ?? "",
              //   userImage: userInfo.image ?? "",
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // TextFieldSelectStoreHomeTab(),
                        // HomeTabActionButtonsList(),
                        // HomeTabActionButtonsDotsList(),
                        // HomeTabHeaderButtonsList()
                        !StringHelper.isEmptyString(dashboardController
                                .storeNameController.value.text)
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 12),
                                child: PrimaryTextView(
                                  text: dashboardController
                                      .storeNameController.value.text,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: primaryTextColor,
                                ),
                              )
                            : Container(),
                        DashboardStockCountItem(
                          title: 'in_stock'.tr,
                          value: "2",
                          valueColor: Colors.green,
                        ),

                        DashboardStockCountItem(
                          title: 'low_stock'.tr,
                          value: "5",
                          valueColor: Colors.orange,
                        ),

                        DashboardStockCountItem(
                          title: 'out_of_stock'.tr,
                          value: "1",
                          valueColor: Colors.red,
                        )
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                child: Row(
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: PrimaryBorderButton(
                          buttonText: 'download'.tr,
                          textColor: defaultAccentColor,
                          borderColor: defaultAccentColor,
                          onPressed: () {},
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryBorderButton(
                        buttonText: 'upload'.tr,
                        textColor: defaultAccentColor,
                        borderColor: defaultAccentColor,
                        onPressed: () {},
                      ),
                    )
                  ],
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
