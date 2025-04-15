import 'package:flutter/material.dart';

import '../res/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double? borderRadius;
  final double? fontSize, buttonHeight;
  final FontWeight? fontWeight;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const PrimaryButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.borderRadius,
      this.buttonHeight,
      this.fontSize,
      this.fontWeight,
      this.buttonColor,
      this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      color: buttonColor ?? defaultAccentColor,
      elevation: 0,
      height: buttonHeight ?? 48,
      splashColor: Colors.white.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
      child: Text(buttonText,
          style: TextStyle(
            color: buttonTextColor ?? Colors.white,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: fontSize ?? 16,
          )),
    );
  }
}
