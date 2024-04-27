import 'package:flutter/cupertino.dart';
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
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../common/widgets/common_bottom_navigation_bar_widget.dart';
import '../dashboard/widgets/main_drawer.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  final stockListController = Get.put(StockListController());
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: Obx(() => Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'stocks'.tr,
              isBack: true,
              widgets: actionButtons()),
          drawer: MainDrawer(),
          bottomNavigationBar: const CommonBottomNavigationBarWidget(),
          body: ModalProgressHUD(
            inAsyncCall: stockListController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: RefreshIndicator(
              onRefresh: () async {
                await stockListController.getStockListApi(false, false, "");
              },
              child: Column(children: [
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
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
        )));
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
      Visibility(
        visible: stockListController.isScanQrCode.value,
        child: InkWell(
            onTap: () {
              stockListController.addStockProductScreen();
            },
            child: Text(
              'add_new_product'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  color: defaultAccentColor,
                  fontWeight: FontWeight.w500),
            )),
      ),
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
}
