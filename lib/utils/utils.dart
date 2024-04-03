import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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
                  style: const TextStyle(color: Colors.white),
                ))),
        margin: const EdgeInsets.all(10));
  }

  static Future<String> getDeviceName() async {
    String deviceName = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model.isNotEmpty?androidInfo.model:"";
    }else if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine.isNotEmpty?iosInfo.utsname.machine:"";
    }
    return deviceName;
  }
}
