import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(
      {super.key, this.onValueChange, this.onPressedClear, this.controller});

  final ValueChanged<String>? onValueChange;
  final VoidCallback? onPressedClear;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onValueChange,
      style: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        // prefixIcon: const Icon(Icons.search, color: primaryTextColor),
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
        suffixIcon: IconButton(
          onPressed: onPressedClear,
          icon: const Icon(Icons.cancel),
        ),
      ),
    );
  }
}
