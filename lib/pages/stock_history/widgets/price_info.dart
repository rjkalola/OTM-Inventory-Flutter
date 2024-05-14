import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';

import '../../../utils/image_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../widgets/text/PrimaryTextView.dart';
class QtyHistoryPriceInfo extends StatelessWidget {
  QtyHistoryPriceInfo({super.key,this.price});
  final String? price;
  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(price)
        ? Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: PrimaryTextView(
        text: price ??
            "",
        fontSize: 15,
      softWrap: true,
      ),
    )
        : Container();
  }
}
