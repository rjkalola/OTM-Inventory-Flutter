import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_response.dart';
import 'package:otm_inventory/pages/otp_verification/verify_otp_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../../utils/Utils.dart';
import 'package:dio/dio.dart' as multi;

import '../../web_services/api_constants.dart';
import '../../web_services/response/response_model.dart';

class VerifyOtpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final box1 = TextEditingController().obs;
  final box2 = TextEditingController().obs;
  final box3 = TextEditingController().obs;
  final box4 = TextEditingController().obs;
  final mExtension = "".obs;
  final mPhoneNumber = "".obs;
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final _api = VerifyOtpRepository();

  void onSubmitOtpClick() {
    if (box1.value.text.toString().isNotEmpty &&
        box2.value.text.toString().isNotEmpty &&
        box3.value.text.toString().isNotEmpty &&
        box4.value.text.toString().isNotEmpty) {
      String otp = box1.value.text.toString() +
          box2.value.text.toString() +
          box3.value.text.toString() +
          box4.value.text.toString();
      verifyOtp(otp);
    } else {
      showSnackBar('enter_otp'.tr);
    }
  }

  void verifyOtp(String code) async {
    if (formKey.currentState!.validate()) {
      String deviceModelName = "";
      print("deviceModelName:" + deviceModelName);
      Map<String, dynamic> map = {};
      // map["email"] = mExtension.value + mPhoneNumber.value;
      map["email"] = "+918866270586";
      map["verification_code"] = code;
      map["password"] = "";
      map["save_login"] = "0";
      map["user_id"] = "0";
      map["device_type"] = AppConstants.deviceType;
      map["model_name"] = deviceModelName;

      multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.verifyOtp(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.statusCode == 200) {
            UserResponse response =
                UserResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.isSuccess!) {
              showSnackBar(response.message!);
            } else {
              showSnackBar(response.message!);
            }
          } else {
            showSnackBar(responseModel.statusMessage!);
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            showSnackBar('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            showSnackBar(error.statusMessage!);
          }
        },
      );
    }
  }

  void showSnackBar(String message) {
    Utils.showSnackBarMessage(message);
  }
}
