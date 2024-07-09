import 'package:flutter/material.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';

class OrderDate extends StatelessWidget {
  const OrderDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: PrimaryTextView(
        text: "Order Date: 07/05/2024",
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        softWrap: true,
      ),
    );
  }
}
