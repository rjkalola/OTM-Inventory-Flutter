import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

import 'app_constants.dart';

class AppUtils {
  static var mTime;

  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static showSnackBarMessage(String message) {
    if (message.isNotEmpty) {
      // Fluttertoast.showToast(
      //   msg: message,
      // );
      Get.rawSnackbar(message: message);
    }
  }

  static showToastMessage(String message) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
      );
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

  static Future<String> getDeviceUniqueId() async {
    String deviceId = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    }
    return deviceId;
  }

  static haxColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  static Future<bool> interNetCheck() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(minutes: 3); //3 minutes
      dio.options.receiveTimeout = const Duration(minutes: 3); //3 minutes
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  static bool isPermission(bool? value) {
    return value != null && value;
  }

  static Color getPurchaseOrderStatusColor(int status) {
    if (status == AppConstants.purchaseOrderStatus.ISSUED) {
      return Colors.blue;
    } else if (status == AppConstants.purchaseOrderStatus.PARTIALLY_RECEIVED) {
      return Colors.orange;
    } else if (status == AppConstants.purchaseOrderStatus.RECEIVED) {
      return Colors.green;
    } else if (status == AppConstants.purchaseOrderStatus.UNLOCKED) {
      return Colors.red;
    } else if (status == AppConstants.purchaseOrderStatus.CANCELLED) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  static Color getStatusTextColor(int status) {
    print("status:" + status.toString());
    Color? color = primaryTextColor;
    if (status == AppConstants.orderStatus.PLACED) {
      color = const Color(0xff1d7b3e);
    } else if (status == AppConstants.orderStatus.ACCEPTED) {
      color = const Color(0xff019ea4);
    } else if (status == AppConstants.orderStatus.REJECTED) {
      color = const Color(0xfff24726);
    } else if (status == AppConstants.orderStatus.IN_PROGRESS) {
      color = defaultAccentColor;
    } else if (status == AppConstants.orderStatus.READY_TO_DELIVERED) {
      color = const Color(0xff414bb2);
    } else if (status == AppConstants.orderStatus.RECEIVED) {
      color = const Color(0xff1d7b3e);
    } else if (status == AppConstants.orderStatus.DELIVERED) {
      color = const Color(0xff025393);
    } else if (status == AppConstants.orderStatus.CANCELLED) {
      color = const Color(0xfff24726);
    } else if (status == AppConstants.orderStatus.RETURNED) {
      color = const Color(0xff1d7b3e);
    }
    return color;
  }

  static BoxDecoration getGrayBorderDecoration(
      {Color? color,
        double? radius,
        double? borderWidth,
        Color? borderColor,
        List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: color ?? Colors.transparent,
      boxShadow: boxShadow ?? null,
      border: Border.all(
          width: borderWidth ?? 0.6, color: borderColor ?? Colors.transparent),
      borderRadius: BorderRadius.circular(radius ?? 12),
    );
  }
}
