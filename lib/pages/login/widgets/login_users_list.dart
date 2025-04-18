import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_controller.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../../../utils/app_storage.dart';
import '../../../widgets/PrimaryBorderButton.dart';
import '../../../widgets/text/PrimaryTextView.dart';
import '../login_controller.dart';

class LoginUsersList extends StatelessWidget {
  LoginUsersList({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: loginController.loginUsers.isNotEmpty,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                loginController.loginUsers.length,
                (position) => InkWell(
                  onTap: () {
                    loginController.login(
                        loginController.loginUsers[position].phoneExtension ??
                            "",
                        loginController.loginUsers[position].phone ?? "",
                        true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 2, 12),
                    child: Row(children: [
                      ImageUtils.setUserImage(
                          loginController.loginUsers[position].imageThumb ?? "",
                          50,
                          50,
                          45),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        child: PrimaryTextView(
                          text:
                              "${loginController.loginUsers[position].firstName} ${loginController.loginUsers[position].lastName}",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                      IconButton(
                          onPressed: () {
                            loginController.loginUsers.removeAt(position);
                            Get.find<AppStorage>()
                                .setLoginUsers(loginController.loginUsers);
                            loginController.loginUsers.refresh();
                          },
                          icon: const Icon(Icons.close))
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void showPopupMenu() {
    PopupMenuButton<String>(
      onSelected: (index) {},
      itemBuilder: (BuildContext context) {
        return {'remove'.tr}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
