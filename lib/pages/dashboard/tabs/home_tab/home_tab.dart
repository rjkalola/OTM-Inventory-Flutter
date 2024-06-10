import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/dashboard_stock_count_item.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_storage.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/PrimaryBorderButton.dart';
import '../../../../widgets/text/PrimaryTextView.dart';

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
        child: Obx(() => Scaffold(
              // backgroundColor: const Color(0xfff4f5f7),
              body: Visibility(
                visible: dashboardController.isMainViewVisible.value,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 1,
                                height: 1,
                                color: dividerColor,
                              ),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 6, 16, 12),
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
                                value: dashboardController.mInStockCount
                                    .toString(),
                                valueColor: Colors.green,
                                onPressed: () {
                                  dashboardController.onClickStockItem(
                                      AppConstants.stockCountType.inStock);
                                },
                              ),

                              DashboardStockCountItem(
                                title: 'low_stock'.tr,
                                value: dashboardController.mLowStockCount
                                    .toString(),
                                valueColor: Colors.orange,
                                onPressed: () {
                                  dashboardController.onClickStockItem(
                                      AppConstants.stockCountType.lowStock);
                                },
                              ),

                              DashboardStockCountItem(
                                title: 'out_of_stock'.tr,
                                value: dashboardController.mOutOfStockCount
                                    .toString(),
                                valueColor: Colors.red,
                                onPressed: () {
                                  dashboardController.onClickStockItem(
                                      AppConstants.stockCountType.outOfStock);
                                },
                              ),

                              DashboardStockCountItem(
                                title: 'minus_stock'.tr,
                                value: dashboardController.mMinusStockCount
                                    .toString(),
                                valueColor: Colors.red,
                                onPressed: () {
                                  dashboardController.onClickStockItem(
                                      AppConstants.stockCountType.minusStock);
                                },
                              ),
                            ]),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      //   child: PrimaryTextView(
                      //     text: 'msg_press_upload_button_before_download'.tr,
                      //     color: primaryTextColor,
                      //     fontSize: 13,
                      //     softWrap: true,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child:  SizedBox(
                          width: double.infinity,
                          child: PrimaryBorderButton(
                            buttonText:
                            'sync'.tr,
                            textColor: defaultAccentColor,
                            borderColor: defaultAccentColor,
                            onPressed: () {
                              dashboardController
                                  .onClickDownloadStockButton();
                            },
                          ),
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.stretch,
                        //   children: [
                        //     PrimaryBorderButton(
                        //       buttonText:
                        //           dashboardController.downloadTitle.value,
                        //       textColor: Colors.green,
                        //       borderColor: Colors.green,
                        //       onPressed: () {
                        //         dashboardController
                        //             .onClickDownloadStockButton();
                        //       },
                        //     ),
                        //     const SizedBox(
                        //       height: 16,
                        //     ),
                        //     PrimaryBorderButton(
                        //       buttonText: 'upload'.tr,
                        //       textColor: defaultAccentColor,
                        //       borderColor: defaultAccentColor,
                        //       onPressed: () {
                        //         dashboardController.onClickUploadStockButton();
                        //       },
                        //     )
                        //   ],
                        // ),
                      )
                    ]),
              ),
            )),
      );
    }));
  }

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
