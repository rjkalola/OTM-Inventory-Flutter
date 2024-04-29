import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/pages/stock_list/widgets/qr_code_icon.dart';
import 'package:otm_inventory/pages/stock_list/widgets/search_stock.dart';
import 'package:otm_inventory/pages/stock_list/widgets/stock_empty_view.dart';
import 'package:otm_inventory/pages/stock_list/widgets/stock_list.dart';
import 'package:otm_inventory/utils/app_utils.dart';

import '../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../../../widgets/CustomProgressbar.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        print("Back Call");
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: SafeArea(
          child: Obx(() => Scaffold(
            backgroundColor: backgroundColor,
            // appBar: BaseAppBar(
            //     appBar: AppBar(),
            //     title: 'stocks'.tr,
            //     isBack: true,
            //     widgets: actionButtons()),
            // drawer: MainDrawer(),
            // bottomNavigationBar: const CommonBottomNavigationBarWidget(),
            body: ModalProgressHUD(
              inAsyncCall: stockListController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: RefreshIndicator(
                onRefresh: () async {
                  await stockListController.getStockListApi(
                      false, false, "");
                },
                child: Column(children: [
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: dividerColor,
                  ),
                  // const SizedBox(height:20,),
                  // TextFieldSelectStore(),
                  Row(
                    children: [
                      const Expanded(child: SearchStockWidget()),
                      QrCodeIcon()
                    ],
                  ),
                  stockListController.productList.isNotEmpty
                      ? StockListView()
                      : StockListEmptyView(),
                  const SizedBox(
                    height: 12,
                  ),
                ]),
              ),
            ),
          ))),
    );
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
      IconButton(
        icon: SvgPicture.asset(
          width: 22,
          Drawable.filterIcon,
        ),
        onPressed: () {},
      ),
      // IconButton(
      //   icon: const Icon(Icons.add, size: 24,color: primaryTextColor),
      //   onPressed: () {
      //     // stockListController.addStockClick(null);
      //   },
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
