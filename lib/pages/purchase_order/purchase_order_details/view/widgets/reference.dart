import 'package:flutter/material.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';

class Reference extends StatelessWidget {
  const Reference({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: PrimaryTextView(
        text:
        "Ref: this is just test note this is just test note this is just test note",
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        softWrap: true,
      ),
    );
  }
}
