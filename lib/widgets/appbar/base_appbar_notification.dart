import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class BaseAppbarNotification extends StatelessWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final isCenterTitle;
  final List<Widget>? widgets;

  BaseAppbarNotification(
      {super.key,
      required this.appBar,
      this.title,
      this.isCenterTitle,
      this.isBack = false,
      this.widgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: widgets,
        centerTitle: isCenterTitle,
        titleSpacing: isBack ? 0 : 20,
        automaticallyImplyLeading: isBack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(AppRoutes.dashboardScreen);
          },
        ),
        scrolledUnderElevation: 0);
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);


}
