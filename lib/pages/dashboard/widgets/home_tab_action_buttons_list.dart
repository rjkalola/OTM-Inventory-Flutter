import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/data_utils.dart';
import '../dashboard_controller.dart';
import '../models/DashboardActionItemInfo.dart';

class HomeTabActionButtonsList extends StatelessWidget {
  HomeTabActionButtonsList({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.only(top: 22),
      child: PageView.builder(
          itemCount: dashboardController.listHeaderButtons.length,
          onPageChanged: (int page) {
            dashboardController.selectedActionButtonPagerPosition.value = page;
          },
          itemBuilder: (context, index) {
            return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(
                  dashboardController.listHeaderButtons[index].length,
                  (position) {
                    return InkWell(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(14),
                              width: 80,
                              height: 54,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(AppUtils.haxColor(
                                      dashboardController.listHeaderButtons[index][position].backgroundColor!))),
                              child: SvgPicture.asset(
                                dashboardController.listHeaderButtons[index][position].image!,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              dashboardController.listHeaderButtons[index][position].title!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        dashboardController
                            .onActionButtonClick(dashboardController.listHeaderButtons[index][position].id!);
                      },
                    );
                  },
                ));
          }),
    );
  }
}