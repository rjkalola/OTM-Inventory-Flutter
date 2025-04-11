import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class TitleTextView extends StatelessWidget {
  TitleTextView({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Text(
        title,
        style: const TextStyle(
            color: primaryTextColor, fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}
