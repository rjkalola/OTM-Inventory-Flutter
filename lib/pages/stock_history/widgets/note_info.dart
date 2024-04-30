import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';

import '../../../utils/image_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../widgets/text/PrimaryTextView.dart';
class QtyHistoryNoteInfo extends StatelessWidget {
  QtyHistoryNoteInfo({super.key,this.note});
  final String? note;
  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(note)
        ? Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: PrimaryTextView(
        text: note ??
            "",
        fontSize: 15,
      ),
    )
        : Container();
  }
}
