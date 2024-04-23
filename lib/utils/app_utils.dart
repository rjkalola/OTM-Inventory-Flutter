import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors.dart';

class AppUtils {
  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static showSnackBarMessage(String message) {
    if (message.isNotEmpty) {
      Get.snackbar('', '',
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          backgroundColor: snackBarColor,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Container(),
          messageText: Center(
              child: Text(message,
                  style: const TextStyle(
                    color: Colors.white,
                  ))),
          margin: const EdgeInsets.all(10));
    }
  }

  static Future<String> getDeviceName() async {
    String deviceName = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model.isNotEmpty ? androidInfo.model : "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName =
          iosInfo.utsname.machine.isNotEmpty ? iosInfo.utsname.machine : "";
    }
    return deviceName;
  }

  static haxColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

}
