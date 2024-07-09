import 'package:flutter/material.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';

class SupplierName extends StatelessWidget {
  const SupplierName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: PrimaryTextView(
        text: "Supplier Name",
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
