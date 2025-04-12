import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/pages/stock_list/widgets/pull_to_refresh_view.dart';
import 'package:otm_inventory/pages/stock_list/widgets/qr_code_icon.dart';
import 'package:otm_inventory/pages/stock_list/widgets/search_stock.dart';
import 'package:otm_inventory/pages/stock_list/widgets/stock_empty_view.dart';
import 'package:otm_inventory/pages/stock_list/widgets/stock_filter_icon.dart';
import 'package:otm_inventory/pages/stock_list/widgets/stock_list.dart';
import 'package:otm_inventory/utils/app_utils.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../widgets/appbar/base_appbar.dart';
import '../dashboard/widgets/main_drawer.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  final stockListController = Get.put(StockListController());
  DateTime? currentBackPressTime;
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => Container(
          color: backgroundColor,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
                appBar: AppBar(),
                title: stockListController.mTitle.value,
                isCenterTitle: false,
                isBack: true,
                widgets: actionButtons()),
            floatingActionButton: (stockListController
                        .totalPendingCount.value ==
                    0)
                ? FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.green,
                    tooltip: '',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    onPressed: () {
                      AppUtils.showSnackBarMessage('data_is_up_to_date'.tr);
                    },
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 25),
                  )
                : SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      backgroundColor: defaultAccentColor,
                      onPressed: () {
                        if (!stockListController.isUploadInProgress.value) {
                          print("....Button Clicked.....");
                          stockListController.isUploadInProgress.value = true;
                          print(
                              "....stockListController.isUploadInProgress....." +
                                  stockListController.isUploadInProgress.value
                                      .toString());
                          stockListController.onCLickUploadData(
                              true,
                              false,
                              stockListController.localStockCount(),
                              stockListController.localProductCount());
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      label: Text(
                        stockListController.totalPendingCount.value.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      icon: const Icon(Icons.autorenew_outlined,
                          color: Colors.white, size: 24),
                    ),
                  ),
            drawerScrimColor: Colors.transparent,
            drawer: MainDrawer(),
            // bottomNavigationBar: const CommonBottomNavigationBarWidget(),
            body: Column(
              children: [
                Expanded(
                  child: ModalProgressHUD(
                    inAsyncCall: stockListController.isLoading.value,
                    opacity: 0,
                    progressIndicator: const CustomProgressbar(),
                    child: RefreshIndicator(
                        onRefresh: () async {
                          stockListController.pullToRefreshTime.value = "";
                          stockListController.pullToRefreshVisible.value =
                              false;
                          await stockListController.onCLickUploadData(
                              true,
                              true,
                              stockListController.localStockCount(),
                              stockListController.localProductCount());
                        },
                        child: Column(children: [
                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: dividerColor,
                          ),
                          // const SizedBox(height:20,),
                          // TextFieldSelectStore(),
                          PullToRefreshView(),
                          const SizedBox(
                            height: 9,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StockFilterIcon(),
                              // StockFilterClearIcon(),
                              const Expanded(child: SearchStockWidget()),
                              QrCodeIcon()
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          stockListController.productList.isNotEmpty
                              ? StockListView()
                              : StockListEmptyView(),
                          const SizedBox(
                            height: 6,
                          ),
                          Visibility(
                            visible: stockListController.isLoadMore.value,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator()),
                                  const SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                    'loading_more_'.tr,
                                    style: const TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // UploadStockButtonWidget()
                        ])),
                  ),
                ),
                // CountButtonsView()
              ],
            ),
          )),
        ));
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: productListController.productList.isNotEmpty,
      //   child: IconButton(
      //     icon: SvgPicture.asset(
      //       width: 22,with exception
      //       Drawable.searchIcon,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // Visibility(
      //   visible: stockListController.isScanQrCode.value,
      //   child: InkWell(
      //       onTap: () {
      //         stockListController.addStockProductScreen();
      //       },
      //       child: Text(
      //         'add_new_product'.tr,
      //         style: const TextStyle(
      //             fontSize: 16,
      //             color: defaultAccentColor,
      //             fontWeight: FontWeight.w500),
      //       )),
      // ),
      // IconButton(
      //   icon: const Icon(Icons.add, size: 24,color: primaryTextColor),
      //   onPressed: () {
      //     // stockListController.addStockClick(null);
      //   },
      // ),
      InkWell(
          onTap: () {
            stockListController.addMultipleStockQuantity();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              "+${'add_stock'.tr}",
              style: const TextStyle(
                  fontSize: 16,
                  color: defaultAccentColor,
                  fontWeight: FontWeight.w500),
            ),
          )),
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
