import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';

import '../../../res/colors.dart';
import '../../../utils/image_utils.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key});
  var userInfo = Get.find<AppStorage>().getUserInfo();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(),
          drawerItem(
            text: 'dashboard'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.dashboardScreen),
            tileColor: getItemBgColor(AppRoutes.dashboardScreen),
            onTap: () {
              navigate(AppRoutes.dashboardScreen);
            },
          ),
          drawerItem(
            text: 'products'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.productListScreen),
            tileColor: getItemBgColor(AppRoutes.productListScreen),
            onTap: () {
              navigate(AppRoutes.productListScreen);
            },
          ),
          // drawerItem(
          //   text: 'stores'.tr,
          //   iconPath: Drawable.homeDrawerIcon,
          //   textIconColor: getItemColor(AppRoutes.storeListScreen),
          //   tileColor: getItemBgColor(AppRoutes.storeListScreen),
          //   onTap: () {
          //     navigate(AppRoutes.storeListScreen);
          //   },
          // ),
          Visibility(
            visible: AppStorage.storeId != 0,
            child: drawerItem(
              text: 'stocks'.tr,
              iconPath: Drawable.homeDrawerIcon,
              textIconColor: getItemColor(AppRoutes.stockListScreen),
              tileColor: getItemBgColor(AppRoutes.stockListScreen),
              onTap: () {
                navigate(AppRoutes.stockListScreen);
              },
            ),
          ),
          drawerItem(
            text: 'vendors'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.storeListScreen),
            tileColor: getItemBgColor(AppRoutes.storeListScreen),
            onTap: () {
              navigate(AppRoutes.storeListScreen);
            },
          ),
          drawerItem(
            text: 'manufacturer'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.storeListScreen),
            tileColor: getItemBgColor(AppRoutes.storeListScreen),
            onTap: () {
              navigate(AppRoutes.storeListScreen);
            },
          ),
          drawerItem(
            text: 'categories'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.categoryListScreen),
            tileColor: getItemBgColor(AppRoutes.categoryListScreen),
            onTap: () {
              navigate(AppRoutes.categoryListScreen);
            },
          ),
          drawerItem(
            text: 'suppliers'.tr,
            iconPath: Drawable.homeDrawerIcon,
            textIconColor: getItemColor(AppRoutes.supplierListScreen),
            tileColor: getItemBgColor(AppRoutes.supplierListScreen),
            onTap: () {
              navigate(AppRoutes.supplierListScreen);
            },
          ),
        ],
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
          ImageUtils.setUserImage(userInfo.image ?? "", 66, 45),
      currentAccountPictureSize: const Size.square(66),
    );
  }

  Widget drawerItem(
      {required String text,
      required String iconPath,
      required Color textIconColor,
      required Color tileColor,
      required VoidCallback onTap}) {
    return ListTile(
      leading: SvgPicture.asset(
        width: 28,
        height: 28,
        iconPath,
        // color: primaryTextColor,
        colorFilter:
         ColorFilter.mode(textIconColor, BlendMode.srcIn),
      ),
      title: Text(
        text,
        style: TextStyle(color: textIconColor,),
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
    Get.back();
    Get.offNamed(routPath);
  }
}
