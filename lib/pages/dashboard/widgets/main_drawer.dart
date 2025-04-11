import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';

import '../../../res/colors.dart';
import '../../../utils/AlertDialogHelper.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/image_utils.dart';
import '../../common/listener/DialogButtonClickListener.dart';
import '../../stock_list/stock_list_controller.dart';
import '../dashboard_controller.dart';

class MainDrawer extends StatelessWidget implements DialogButtonClickListener {
  MainDrawer({super.key, this.paddingHeight});

  var userInfo = Get.find<AppStorage>().getUserInfo();
  final double? paddingHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: (kToolbarHeight ?? 0) + 1),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Drawer(
          backgroundColor: backgroundColor,
          surfaceTintColor: backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // drawerHeader(),
              drawerItem(
                text: 'dashboard'.tr,
                iconPath: Drawable.homeDrawerIcon,
                iconPadding: 1,
                textIconColor: getItemColor(AppRoutes.dashboardScreen),
                tileColor: getItemBgColor(AppRoutes.dashboardScreen),
                rout: AppRoutes.dashboardScreen,
                onTap: () {
                  navigate(AppRoutes.dashboardScreen);
                },
              ),
              drawerItem(
                text: 'stocks'.tr,
                iconPath: Drawable.stockDrawerIcon,
                iconPadding: 1,
                textIconColor: getItemColor(AppRoutes.stockListScreen),
                tileColor: getItemBgColor(AppRoutes.stockListScreen),
                rout: AppRoutes.stockListScreen,
                onTap: () {
                  navigate(AppRoutes.stockListScreen);
                },
              ),
              drawerItem(
                text: 'products'.tr,
                iconPath: Drawable.productsDrawerIcon,
                textIconColor: getItemColor(AppRoutes.productListScreen),
                tileColor: getItemBgColor(AppRoutes.productListScreen),
                rout: AppRoutes.productListScreen,
                onTap: () {
                  navigate(AppRoutes.productListScreen);
                },
              ),
              drawerItem(
                text: 'orders'.tr,
                iconPath: Drawable.purchaseOrderDrawerIcon,
                textIconColor: getItemColor(AppRoutes.orderListScreen),
                tileColor: getItemBgColor(AppRoutes.orderListScreen),
                rout: AppRoutes.orderListScreen,
                onTap: () {
                  navigate(AppRoutes.orderListScreen);
                },
              ),
              drawerItem(
                text: 'purchase_order'.tr,
                iconPath: Drawable.purchaseOrderDrawerIcon,
                textIconColor: getItemColor(AppRoutes.purchaseOrderListScreen),
                tileColor: getItemBgColor(AppRoutes.purchaseOrderListScreen),
                rout: AppRoutes.purchaseOrderListScreen,
                onTap: () {
                  navigate(AppRoutes.purchaseOrderListScreen);
                },
              ),
              drawerItem(
                text: 'stores'.tr,
                iconPath: Drawable.storeDrawerIcon,
                iconPadding: 2,
                textIconColor: getItemColor(AppRoutes.storeListScreen),
                tileColor: getItemBgColor(AppRoutes.storeListScreen),
                rout: AppRoutes.storeListScreen,
                onTap: () {
                  navigate(AppRoutes.storeListScreen);
                },
              ),
              // Visibility(
              //   visible: AppStorage.storeId != 0,
              //   child: drawerItem(
              //     text: 'stocks'.tr,
              //     iconPath: Drawable.homeDrawerIcon,
              //     textIconColor: getItemColor(AppRoutes.stockListScreen),
              //     tileColor: getItemBgColor(AppRoutes.stockListScreen),
              //     onTap: () {
              //       navigate(AppRoutes.stockListScreen);
              //     },
              //   ),
              // ),
              // drawerItem(
              //   text: 'vendors'.tr,
              //   iconPath: Drawable.homeDrawerIcon,
              //   textIconColor: getItemColor(AppRoutes.storeListScreen),
              //   tileColor: getItemBgColor(AppRoutes.storeListScreen),
              //   onTap: () {
              //     navigate(AppRoutes.storeListScreen);
              //   },
              // ),
              // drawerItem(
              //   text: 'manufacturer'.tr,
              //   iconPath: Drawable.homeDrawerIcon,
              //   textIconColor: getItemColor(AppRoutes.storeListScreen),
              //   tileColor: getItemBgColor(AppRoutes.storeListScreen),
              //   onTap: () {
              //     navigate(AppRoutes.storeListScreen);
              //   },
              // ),
              drawerItem(
                text: 'categories'.tr,
                iconPath: Drawable.categoryDrawerIcon,
                iconPadding: 2,
                textIconColor: getItemColor(AppRoutes.categoryListScreen),
                tileColor: getItemBgColor(AppRoutes.categoryListScreen),
                rout: AppRoutes.categoryListScreen,
                onTap: () {
                  navigate(AppRoutes.categoryListScreen);
                },
              ),
              drawerItem(
                text: 'suppliers'.tr,
                iconPath: Drawable.supplierDrawerIcon,
                textIconColor: getItemColor(AppRoutes.supplierListScreen),
                tileColor: getItemBgColor(AppRoutes.supplierListScreen),
                rout: AppRoutes.supplierListScreen,
                onTap: () {
                  navigate(AppRoutes.supplierListScreen);
                },
              ),
              drawerLogoutItem(
                text: 'logout'.tr,
                textIconColor: Colors.red,
                tileColor: Colors.white,
                onTap: () {
                  AlertDialogHelper.showAlertDialog(
                      "",
                      'logout_msg'.tr,
                      'yes'.tr,
                      'no'.tr,
                      "",
                      true,
                      this,
                      AppConstants.dialogIdentifier.logout);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: backgroundColor,
      ),
      accountName:
          Text('${userInfo.firstName ?? ""} ${userInfo.lastName ?? ""}',
              style: const TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              )),
      accountEmail:
          Text('${userInfo.phoneExtension ?? ""} ${userInfo.phone ?? ""}',
              style: const TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              )),
      currentAccountPicture:
          ImageUtils.setUserImage(userInfo.image ?? "", 66, 66, 45),
      currentAccountPictureSize: const Size.square(66),
    );
  }

  Widget drawerItem(
      {required String text,
      required String iconPath,
      required Color textIconColor,
      required Color tileColor,
      required String rout,
      double? iconPadding,
      required VoidCallback onTap}) {
    return Visibility(
      visible: Get.currentRoute != rout,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(iconPadding ?? 0),
              width: 28,
              height: 28,
              child: SvgPicture.asset(
                width: 28,
                height: 28,
                iconPath,
                // color: primaryTextColor,
                colorFilter: ColorFilter.mode(textIconColor, BlendMode.srcIn),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              weight: 300,
            ),
            title: Text(
              text,
              style: TextStyle(
                  color: textIconColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            tileColor: tileColor,
            onTap: onTap,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18),
            child: Divider(
              height: 0,
              color: dividerColor,
            ),
          )
        ],
      ),
    );
  }

  Widget drawerLogoutItem(
      {required String text,
      required Color textIconColor,
      required Color tileColor,
      required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
            color: textIconColor, fontWeight: FontWeight.w500, fontSize: 17),
      ),
      tileColor: tileColor,
      onTap: onTap,
    );
  }

  Color getItemColor(String rout) {
    return Get.currentRoute == rout ? Colors.white : Colors.black;
  }

  Color getItemBgColor(String rout) {
    return Get.currentRoute == rout ? defaultAccentColor : Colors.white;
  }

  navigate(String routPath) {
    // Navigator.pop(context as BuildContext);
    // Get.back();
    if (AppStorage.storeId == 0) {
      if (routPath == AppRoutes.dashboardScreen) Get.offNamed(routPath);
    } else {
      if (Get.currentRoute == AppRoutes.stockListScreen &&
          routPath == AppRoutes.stockListScreen) {
        Get.put(StockListController()).initialDataSet(0, false, true);
        Get.back();
        // StockListController().getStockListApi(true, false, "", true, true);
      } else {
        Get.offNamed(routPath);
      }
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    Get.put(DashboardController()).logoutAPI();
  }
}
