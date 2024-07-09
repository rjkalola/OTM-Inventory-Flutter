import 'package:flutter/material.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryTextView(
            text: "PO-232323",
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          PrimaryTextView(
            text: "Issued",
            color: defaultAccentColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
