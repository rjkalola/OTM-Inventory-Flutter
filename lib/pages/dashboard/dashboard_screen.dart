import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/main_drawer.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../widgets/appbar/base_appbar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() => Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: dashboardController.title.value,
        isBack: true,),
      drawer:  MainDrawer(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          controller: dashboardController.pageController,
          onPageChanged: dashboardController.onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: dashboardController.tabs,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    )));
  }
}
