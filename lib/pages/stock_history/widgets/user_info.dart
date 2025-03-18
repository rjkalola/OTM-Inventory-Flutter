import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';

import '../../../utils/image_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../widgets/text/PrimaryTextView.dart';
class QtyHistoryUserInfo extends StatelessWidget {
   QtyHistoryUserInfo({super.key,this.user});
  final UserInfo? user;
  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyObject(user)
        ? Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 9, 0),
      child: Row(
        children: [
          // ImageUtils.setUserImage(
          //     user!.image ??
          //         "",
          //     36,
          //     36,
          //     45),
          // const SizedBox(
          //   width: 9,
          // ),
          PrimaryTextView(
            text: user!
                .name ??
                "",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    )
        : Container();
  }
}
