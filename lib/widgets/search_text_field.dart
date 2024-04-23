import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, this.onValueChange});

  final ValueChanged<String>? onValueChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onValueChange,
      style: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
        prefixIcon: const Icon(Icons.search, color: primaryTextColor),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(45)),
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(45))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(45))),
        hintText: 'search'.tr,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
      ),
    );
  }
}
