import 'package:flutter/material.dart';

import '../res/colors.dart';

class PrimaryBorderButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PrimaryBorderButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      elevation: 0,
      height: 48,
      splashColor: Colors.white.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),side: const BorderSide(width: 1,color: defaultAccentColor)),
      child: Text(buttonText,
          style: const TextStyle(
            color: defaultAccentColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          )),
    );
  }
}
