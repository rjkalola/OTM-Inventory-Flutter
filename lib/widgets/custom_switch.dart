import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final ValueChanged<bool>? onValueChange;
  final mValue;

  const CustomSwitch(
      {super.key,
      required this.onValueChange,
      required this.mValue});

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      value: mValue,
      onChanged: (value) {
        onValueChange;
      },
    );
  }
}
