import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/widgets/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_empty_view.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_list.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/qr_code_icon.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/search_product.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/permission_handler.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../res/colors.dart';
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
      child: Obx(() => Container(
            color: backgroundColor,
            child: SafeArea(
                child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'products'.tr,
                  isCenterTitle: false,
                  isBack: true,
                  widgets: actionButtons()),
              drawer: MainDrawer(),
              bottomNavigationBar: const CommonBottomNavigationBarWidget(),
              body: ModalProgressHUD(
                inAsyncCall: productListController.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
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
                      // QrCodeIcon()
                    ],
                  ),
                  // Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Icon(
                  //       Icons.keyboard_double_arrow_down_outlined,
                  //       size: 30,
                  //     )),
                  Visibility(
                    visible: productListController.isPrintEnable.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        PrimaryTextView(
                          text: productListController.isCheckAllPrint.value
                              ? 'unselect_all'.tr
                              : 'select_all'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        ),
                        Checkbox(
                            activeColor: defaultAccentColor,
                            value: productListController.isCheckAllPrint.value,
                            onChanged: (isCheck) {
                              productListController.isCheckAllPrint.value =
                                  isCheck!;
                              if (isCheck) {
                                productListController.checkAllProducts();
                              } else {
                                productListController.unCheckAllProducts();
                              }
                            })
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !productListController.isPrintEnable.value,
                    child: const SizedBox(
                      height: 6,
                    ),
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
                // child: RefreshIndicator(
                //   onRefresh: () async {
                //     await productListController.getProductListApi(false, "0", true);
                //   },
                // ),
              ),
            )),
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
      Visibility(
        visible: productListController.isPrintEnable.value,
        child: InkWell(
            onTap: () {
              productListController.isPrintEnable.value = false;
              productListController.selectedPrintProduct.clear();
              productListController.unCheckAllProducts();
              productListController.isCheckAllPrint.value = false;
            },
            child: Text(
              'cancel'.tr,
              style: const TextStyle(
                  fontSize: 16, color: Colors.red, fontWeight: FontWeight.w400),
            )),
      ),
      Visibility(
          visible: productListController.isPrintEnable.value,
          child: const SizedBox(
            width: 10,
          )),
      Visibility(
        visible: productListController.isPrintEnable.value,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
              onTap: () async {
                bool permission = await PermissionHandler.isStoragePermission();
                if (permission) {
                  productListController.selectedPrintProduct.clear();
                  for (var info in productListController.productList) {
                    if (info.checkPrint ?? false) {
                      productListController.selectedPrintProduct.add(info);
                    }
                  }
                  if (productListController.selectedPrintProduct.isNotEmpty) {
                    productListController.onClickPrintButton();
                  } else {
                    AppUtils.showSnackBarMessage('empty_products_selected'.tr);
                  }
                }
              },
              child: Text(
                'print'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    color: defaultAccentColor,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
      Visibility(
        visible: !productListController.isPrintEnable.value,
        child: InkWell(
            onTap: () {
              productListController.isPrintEnable.value = true;
            },
            child: Text(
              'select'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  color: defaultAccentColor,
                  fontWeight: FontWeight.w500),
            )),
      ),
      Visibility(
          visible:
              !AppUtils.isPermission(AppStorage().getPermissions().addProduct),
          child: const SizedBox(
            width: 14,
          )),
      // Visibility(
      //     visible: productListController.isPrintEnable.value,
      //     child: const SizedBox(
      //       width: 16,
      //     )),
      // IconButton(
      //   icon: SvgPicture.asset(
      //     width: 22,
      //     Drawable.filterIcon,
      //   ),
      //   onPressed: () {},
      // ),
      Visibility(
        visible: !productListController.isPrintEnable.value &&
            AppUtils.isPermission(AppStorage().getPermissions().addProduct),
        child: IconButton(
          icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
          onPressed: () {
            productListController.onClickPlusButton();
          },
        ),
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
