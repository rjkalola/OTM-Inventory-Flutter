import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/widgets/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_empty_view.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_list.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/qr_code_icon.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/search_product.dart';

import '../../../../res/colors.dart';
import '../../../../res/drawable.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/appbar/base_appbar.dart';
import '../../../dashboard/widgets/main_drawer.dart';
import '../controller/product_list_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final productListController = Get.put(ProductListController());
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
      child: SafeArea(
          child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'products'.tr,
            isBack: true,
            widgets: actionButtons()),
        drawer: MainDrawer(),
        bottomNavigationBar: const CommonBottomNavigationBarWidget(),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: productListController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: RefreshIndicator(
              onRefresh: () async {
                await productListController.getProductListApi(false, "0", true);
              },
              child: Column(children: [
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SearchProductWidget()),
                    QrCodeIcon()
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                productListController.productList.isNotEmpty
                    ? ProductListView()
                    : ProductListEmptyView(),
                const SizedBox(
                  height: 6,
                ),
                Visibility(
                  visible: productListController.isLoadMore.value,
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
                )
              ]),
            ),
          ),
        ),
      )),
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
      // InkWell(
      //     onTap: () {
      //       print("tap qr code");
      //       productListController.openQrCodeScanner();
      //     },
      //     child: Text(
      //       'qr_code'.tr,
      //       style: const TextStyle(
      //           fontSize: 16,
      //           color: defaultAccentColor,
      //           fontWeight: FontWeight.w500),
      //     )),
      IconButton(
        icon: SvgPicture.asset(
          width: 22,
          Drawable.filterIcon,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
        onPressed: () {
          productListController.addProductClick(null);
        },
      ),
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
