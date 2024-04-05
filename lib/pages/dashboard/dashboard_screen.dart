import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/res/colors.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
    );
  }
}
