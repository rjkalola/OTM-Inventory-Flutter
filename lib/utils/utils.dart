import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors.dart';

class Utils {
  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static showSnackBarMessage(String message) {
    Get.snackbar('', '',
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Container(),
        messageText: Center(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black87),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ))),
        margin: const EdgeInsets.all(10));
  }
}
