import 'package:flutter/material.dart';

import '../res/colors.dart';

class PrimaryBorderButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;

  const PrimaryBorderButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.textColor,
      required this.borderColor});

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
          borderRadius: BorderRadius.circular(4),
          side:  BorderSide(width: 1, color: borderColor)),
      child: Text(buttonText,
          style:  TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          )),
    );
  }
}
