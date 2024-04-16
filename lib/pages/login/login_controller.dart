import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/login_repository.dart';
import 'package:otm_inventory/pages/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/login/models/VerifyPhoneResponse.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../routes/app_routes.dart';
import '../../web_services/response/response_model.dart';
import '../common/phone_extension_list_dialog.dart';
import '../common/listener/SelectPhoneExtensionListener.dart';

class LoginController extends GetxController
    implements SelectPhoneExtensionListener {
  final phoneController = TextEditingController().obs;
  final mExtension = "+91".obs;
  final mFlag = "https://cdn.otmsystem.com//flags//png//in_32.png".obs;
  final formKey = GlobalKey<FormState>();

  final _api = LoginRepository();

  final registerResourcesResponse = RegisterResourcesResponse().obs;
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    getRegisterResources();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map["phone"] = mExtension + phoneController.value.text.toString();
      multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.login(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.statusCode == 200) {
            VerifyPhoneResponse response =
                VerifyPhoneResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.isSuccess!) {
              var arguments = {
                AppConstants.intentKey.phoneExtension: mExtension.value,
                AppConstants.intentKey.phoneNumber:
                    phoneController.value.text.toString(),
              };
              Get.toNamed(AppRoutes.verifyOtpScreen, arguments: arguments);
              // showSnackBar(response.message!);
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

  void getRegisterResources() {
    isLoading.value = true;
    _api.getRegisterResources(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
              jsonDecode(responseModel.result!)));
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_phone_extension'.tr,
            list: registerResourcesResponse.value.countries!,
            listener: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectPhoneExtension(int id,String extension, String flag,String country) {
    mFlag.value = flag;
    mExtension.value = extension;
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;
}
